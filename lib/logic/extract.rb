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
      structMap = StructMap.parse(File.read(structure_path), :single => true)

      article_paths = extract_article_xml_paths(folder)
      sections_ta_paths = extract_sections_ta_xml_paths(folder)

      puts "code: #{code.title} articles paths: #{article_paths.length}"

      article_maps = parse_all_legiarti(article_paths)
      legisctas = parse_all_legiscta sections_ta_paths

      # articles = article_maps.map { |a| a.to_article() }

      sections = legisctas.map { |s| s.to_section() }

      code_section_link_hashs = structMap.to_section_links_hash()
      section_link_hashs = legisctas.map { |s| s.to_section_links_hash() }.compact.flatten

      # article_link_hashs = legisctas.map { |s| s.to_article_links_hash() }

      link_code_sections(code, sections, code_section_link_hashs)
      link_sections(sections, section_link_hashs)
      # link_articles

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

  def parse_all_legiarti(article_paths)
    article_paths.map { |article_path| ArticleMap.parse_with_escape_br(File.read(article_path), :single => true) }
  end

  def parse_all_legiscta paths
    paths.map { |p| LegisctaMap.parse(File.read(p), :single => true) }
  end

  def add_articles_to_sections(code, article_maps, legisctas_map)
    articles = legisctas_map.extract_articles(article_maps)
    if !articles.empty?
      sections = code.sections.find_all { |s| s.id_section_origin == legisctas_map.id }

      if sections.empty?
        puts "!!!!"
        puts "!!!! section #{legisctas_map.id} not found for articles #{articles.map{|a| a.id_article_origin}.join(', ')}"
        puts "!!!!"
      end

      sections.each{ |s| s.articles += articles  }
    end
  end

  def folder_invalid?(structure_path, version_path)
    version_path.nil? || structure_path.nil?
  end

end
