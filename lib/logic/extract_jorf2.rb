require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'

class Extractor

  JCONT_PATTERN = 'conteneur/**/*.xml'

  def initialize update=false
    @update = update
  end

  def extract_conteneur_xml_paths path
    Dir.glob(File.join(path, JCONT_PATTERN))
  end

  def extract_jorf2 path
    jorfcont_paths = extract_conteneur_xml_paths(path)
    Parallel.map(jorfcont_paths, in_processes: ENV['PARALLEL_PROCESSES'].try(:to_i), :progress => "Containers") do |jorfcont_path|
      extract_full_container(jorfcont_path, path)
    end
  end

  def extract_full_container(jorfcont_path, path)
    jorfcont_map = JorfcontMap.parse(File.read(jorfcont_path), :single => true)
    jorfcont = jorfcont_map.to_jorfcont

    # récupérer les texts, avec les struct et les versions, en partant 
    jorfcont_map.link_cont_text_maps.each do |link_cont_text_map|
      id_jorftext_origin = link_cont_text_map.id_jorftext_origin
      jstruct_map = find_jstruct_map_by_id_origin(id_jorftext_origin, path)
      jversion_map = find_jversion_map_by_id_origin(id_jorftext_origin, path)

      if jstruct_map
        jtext = jstruct_map.to_jtext
        jtext.title_full = jversion_map.title_full
        jtext.permanent_link = jversion_map.permanent_link

        jorfcont.jtexts << jtext
        # ajouter les keywords
        jtext.keywords = jversion_map.keywords.map(&:to_keyword)

        # ajouter les liens de niveau 2
        jsections = jstruct_map.link_text_section_maps.map do |link_text_section_map|
          section_map = find_jscta_map_by_id_origin(link_text_section_map.id_jsection_origin, path)

          article_maps = section_map.link_section_article_maps.map do |link_section_article_map|
            find_article_map_by_id_origin(link_section_article_map.id_jarticle_origin, path)
          end

          jsection = section_map.to_jsection
          jarticles = article_maps.map(&:to_jarticle)
          jsection.jarticles = jarticles
          jsection
        end

        jtext.jsections = jsections

        jarticles = jstruct_map.link_text_article_maps.map do |article_map|
          find_article_map_by_id_origin(article_map.id_jarticle_origin, path)
        end.compact.map(&:to_jarticle)

        jtext.jarticles = jarticles
      end
    end

    jtexts = jorfcont.jtexts
    Jorfcont.import([jorfcont], validate: false)
    Jtext.import(jtexts.to_ary, validate: false)
    jorfcont.jorfcont_jtext_links.each{|link| link.jorfcont_id = jorfcont.id; link.jtext_id = link.jtext.id}
    JorfcontJtextLink.import(jorfcont.jorfcont_jtext_links.to_ary, validate: false)

    #import keywords
    keywords = jtexts.map(&:keywords).flatten
    keywords.map{|keyword| keyword.jtext_id = keyword.jtext.id}
    Keyword.import(keywords, validate: false)

    # import sections
    sections = jtexts.map(&:jsections).flatten.compact
    Jsection.import(sections, validate: false)
    links = jtexts.map(&:jtext_jsection_links).flatten.compact.map{|link| link.jtext_id = link.jtext.id; link.jsection_id = link.jsection.id; link}
    JtextJsectionLink.import(links, validate: false)
    # import section articles
    articles = sections.map(&:jarticles).flatten.compact
    Jarticle.import(articles, validate: false)
    links = sections.map(&:jsection_jarticle_links).flatten.compact.map{|link| link.jsection_id = link.jsection.id; link.jarticle_id = link.jarticle.id; link}
    JsectionJarticleLink.import(links, validate: false)

    # import articles
    articles = jtexts.map(&:jarticles).flatten.compact
    Jarticle.import(articles, validate: false)
    links = jtexts.map(&:jtext_jarticle_links).flatten.compact.map{|link| link.jtext_id = link.jtext.id; link.jarticle_id = link.jarticle.id; link}
    JtextJarticleLink.import(links, validate: false)
  end

  def full_path_from_id_origin(id_origin)
    filename = id_origin + ".xml"
    dirname = dirname_from_id_origin(id_origin)
    File.join(dirname, filename)
  end

  def find_jscta_map_by_id_origin(id_origin, path)
    find_x_map_by_id_origin(id_origin, path, JsctaMap, "section_ta/JORF/SCTA")
  end

  def find_article_map_by_id_origin(id_origin, path)
    find_x_map_by_id_origin(id_origin, path, JarticleMap, "article/JORF/ARTI")
  end

  def find_jstruct_map_by_id_origin(id_origin, path)
    find_x_map_by_id_origin(id_origin, path, JstructMap, "texte/struct/JORF/TEXT")
  end

  def find_jversion_map_by_id_origin(id_origin, path)
    find_x_map_by_id_origin(id_origin, path, JversionMap, "texte/version/JORF/TEXT")
  end

  def find_x_map_by_id_origin(id_origin, path, clazz, base_folder)
    full_path = full_path_from_id_origin(id_origin)
    full_path = File.join(path, base_folder, full_path)
    if File.exists?(full_path)
      clazz.send(:parse, File.read(full_path), single: true)
    else
      $stderr.puts "missing #{clazz.to_s} file: #{full_path}"
      nil
    end
  end

  def dirname_from_id_origin(id_origin)
    dirs = id_origin[8..id_origin.length-3]
    dirs[0,2] + "/" + dirs[2,2] + "/" + dirs[4,2] + "/" + dirs[6,2] + "/" + dirs[8,2]
  end

end
