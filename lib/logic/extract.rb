require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'

class Extractor

  VERSION_PATTERN = 'texte/version/*.xml'
  STRUCTURE_PATTERN = 'texte/struct/*.xml'
  TEXTE_PATTERN = '**/LEGITEXT*/'
  SECTION_TA_PATTERN = 'section_ta/**/*.xml'
  ARTICLE_PATTERN = 'article/**/*.xml'

  def extract_text_folder_paths path
    Dir.glob(File.join(path, TEXTE_PATTERN))
  end

  def extract_struct_xml_path path
    Dir.glob(File.join(path, STRUCTURE_PATTERN)).first
  end

  def extract_version_xml_path path
    Dir.glob(File.join(path, VERSION_PATTERN)).first
  end

  def extract_sections_ta_xml_paths path
    Dir.glob(File.join(path, SECTION_TA_PATTERN))
  end

  def extract_article_xml_paths path
    Dir.glob(File.join(path, ARTICLE_PATTERN))
  end

  def get_code_title xml
    xml.TEXTE_VERSION.META.META_SPEC.META_TEXTE_VERSION.TITRE.content
  end

  def escape_title title
    ActiveSupport::Inflector.transliterate(title).downcase.gsub(/[,'\s\(\)]/,'_').gsub(/_+/,'_').gsub(/\W/,'').gsub(/_$/,'')
  end

  def extract_codes_and_sections path
    texte_folders = extract_text_folder_paths(path)
    puts "#{texte_folders.length} text folders detected"

    codes = Parallel.map(texte_folders) do |folder|
      start = Time.now
      puts "processing #{folder}"

      version_path = extract_version_xml_path(folder)
      structure_path = extract_struct_xml_path(folder)

      if folder_invalid?(structure_path, version_path)
        $stderr.puts "invalid texte folder: #{folder}"
        next
      end

      code_title =get_code_title( Nokogiri.Slop(File.read(version_path)))
      puts "Building #{code_title}; #{Time.now - start} (#{folder})"
      code = Code.new(title: code_title, escape_title: escape_title(code_title))

      #puts "code: #{code.title} articles paths: #{article_paths.length}"

      structMap = StructMap.parse(File.read(structure_path), :single => true)
      code_section_link_hashs = structMap.to_section_links_hash()
      sections_ta_paths = extract_sections_ta_xml_paths(folder)
      legisctas = parse_all_legiscta(sections_ta_paths)
      sections = legisctas.map { |s| s.to_section() }
      section_link_hashs = legisctas.map { |s| s.to_section_links_hash() }.compact.flatten
      link_code_sections(code, sections, code_section_link_hashs)
      link_sections(sections, section_link_hashs)

      article_paths = extract_article_xml_paths(folder)
      article_maps = parse_all_legiarti(article_paths)
      articles = article_maps.map { |a| a.to_article() }

      puts "#{code.title} has #{articles.length} articles"

      article_version_hashs = article_maps.map { |a| a.to_article_versions_hash() }.compact.flatten
      version_articles(articles, article_version_hashs)
      article_link_hashs = legisctas.map { |s| s.to_article_links_hash() }.compact.flatten
      link_articles(sections, articles, article_link_hashs)

      code.sections += sections

      puts "#{code.title} is built; #{Time.now - start} (#{folder})"
      
      if code.nil?
        puts "#{code.title} is nil; do not save"
      else
        code.save!
        puts "#{code.title} saved; #{Time.now - start} (#{folder})"
      end
    end

    codes.compact
  end

  def link_code_sections(code, sections, code_section_link_hashs)
    sections_hash = sections.reduce({}) { |h, s| h[s.id_section_origin] = s; h }
    code_section_link_hashs.each do |csl|
      target = sections_hash[csl["target_id_section_origin"]]
      code_section_link = CodeSectionLink.new(code: code, section: target, state: csl['state'], start_date: csl['start_date'], end_date: csl['end_date'], order: csl['order'])
      code.code_section_links << code_section_link
    end
  end

  def link_sections(sections, section_link_hashs)
    sections_hash = sections.reduce({}) { |h, s| h[s.id_section_origin] = s; h }

    section_link_hashs.each do |sl|

      # next link if link to the code
      # to test
      if sl['source_id_section_origin'].start_with?('LEGITEXT')
        next
      end

      source = sections_hash[sl["source_id_section_origin"]]
      target = sections_hash[sl["target_id_section_origin"]]
      section_link = SectionLink.new(source: source, target: target, state: sl['state'], start_date: sl['start_date'], end_date: sl['end_date'])
      source.section_links << section_link
    end
  end

  def version_articles(articles, article_version_hashs)
    articles_hash = articles.reduce({}) { |h, a| h[a.id_article_origin] = a; h }

    article_version_hashs.each do |av|
      articles_hash[av["source_id_article_origin"]].versions << articles_hash[av["id_article_origin"]]
    end
  end

  def link_articles(sections, articles, article_link_hashs)
    sections_hash = sections.reduce({}) { |h, s| h[s.id_section_origin] = s; h }
    articles_hash = articles.reduce({}) { |h, a| h[a.id_article_origin] = a; h }

    article_link_hashs.each do |al|
      section_source = sections_hash[al["source_id_section_origin"]]
      article_target = articles_hash[al["target_id_article_origin"]]
      article_link = SectionArticleLink.new(section: section_source, article: article_target, state: al['state'], start_date: al['start_date'], end_date: al['end_date'], order: al['order'])
      section_source.section_article_links << article_link
    end
  end

  def parse_all_legiarti(article_paths)
    article_paths.map { |article_path| ArticleMap.parse_with_escape_br(File.read(article_path), :single => true) }
  end

  def parse_all_legiscta paths
    paths.map { |p| LegisctaMap.parse(File.read(p), :single => true) }
  end

  def folder_invalid?(structure_path, version_path)
    version_path.nil? || structure_path.nil?
  end

end
