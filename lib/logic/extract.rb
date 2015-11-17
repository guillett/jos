require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'
require './lib/logic/helpers/article_helper'

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
      puts "processing #{folder}"

      version_path = extract_version_xml_path(folder)
      structure_path = extract_struct_xml_path(folder)

      if folder_invalid?(structure_path, version_path)
        $stderr.puts "invalid texte folder: #{folder}"
        next
      end

      code_title =get_code_title( Nokogiri.Slop(File.read(version_path)))

      code = Code.new(title: code_title, escape_title: escape_title(code_title))
      structMap = StructMap.parse(File.read(structure_path), :single => true)

      code.sections = structMap.extract_sections()

      article_paths = extract_article_xml_paths(folder)
      article_maps = article_paths.map do |article_path|
        ArticleMap.parse(replace_br_tags(File.read(article_path)), :single => true)
      end

      sections_ta_paths = extract_sections_ta_xml_paths(folder)
      sections_ta_paths.each do |section_ta|
        legisctaMap = LegisctaMap.parse(File.read(section_ta), :single => true)

        code.sections += legisctaMap.extract_sections()

        articles = legisctaMap.extract_articles(article_maps)

        articles.each do |article|
          section = code.sections.find{|s| s.id_section_origin == legisctaMap.id }
          unless section.nil?
            section.articles.push(article)
          end
        end

      end

      puts "#{code.title} is built"
      code
    end

    codes.select{|c| !c.nil? }
  end

  def folder_invalid?(structure_path, version_path)
    version_path.nil? || structure_path.nil?
  end

end
