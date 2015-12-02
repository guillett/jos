require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'

class Extractor

  JTEXT_STRUCTURE_PATTERN = 'texte/struct/**/*.xml'
  JTEXT_VERSION_PATTERN = 'texte/version/**/*.xml'
  JCONT_PATTERN = 'conteneur/**/*.xml'
  JSECTION_PATTERN = 'section_ta/**/*.xml'
  JARTICLE_PATTERN = 'article/**/*.xml'

  def extract_struct_xml_paths path
    Dir.glob(File.join(path, JTEXT_STRUCTURE_PATTERN))
  end

  def extract_version_xml_paths path
    Dir.glob(File.join(path, JTEXT_VERSION_PATTERN))
  end

  def extract_conteneur_xml_paths path
    Dir.glob(File.join(path, JCONT_PATTERN))
  end

  def extract_jsection_xml_paths path
    Dir.glob(File.join(path, JSECTION_PATTERN))
  end
  
  def extract_jarticle_xml_paths path
    Dir.glob(File.join(path, JARTICLE_PATTERN))
  end

  def extract_jorf path
    jcont_maps = extract_jcont_maps(path)
    puts "#{jcont_maps.length} jcont_maps extracted"
    jconts = jcont_maps.map(&:to_jorfcont)
    jcont_jtext_link_hashes = jcont_maps.map(&:to_jorfcont_jorftext_link_hashes).compact.flatten

    jstruct_maps = extract_jstruct_maps(path)
    puts "#{jstruct_maps.length} jstruct_maps extracted"
    jtexts = jstruct_maps.map(&:to_jtext)

    jversion_maps = extract_jversion_maps(path)
    puts "#{jversion_maps.length} jversion_maps extracted"
    keywords = complete_jtexts_and_returns_keywords(jtexts, jversion_maps)

    Keyword.import keywords
    Jorfcont.import jconts
    Jtext.import jtexts
    puts "keywords jorfcont jtext imported"

    jtext_keword_hashes = jtexts.map(&:jtext_keywords).flatten.each{|jk| jk.jtext_id = jk.jtext.id; jk.keyword_id = jk.keyword.id; }
    jtext_kewords = build_jtext_kewords(jtext_keword_hashes)
    JtextKeyword.import jtext_kewords


    jconts_hash = jconts.reduce({}) { |h, jorfcont| h[jorfcont.id_jorfcont_origin] = jorfcont; h }
    jtexts_hash = jtexts.reduce({}) { |h, jorftext| h[jorftext.id_jorftext_origin] = jorftext; h }

    jcont_jtext_links = build_jorfcont_jorftext_links(jcont_jtext_link_hashes, jconts_hash, jtexts_hash)

    JorfcontJtextLink.import jcont_jtext_links

    jsections_maps = extract_jsection_maps(path)
    puts "#{jsections_maps.length} jsections_maps extracted"
    jsections = jsections_maps.map(&:to_jsection)
    Jsection.import jsections
    jsections_hash = jsections.reduce({}) { |h, jsection| h[jsection.id_jsection_origin] = jsection; h }

    jtext_jsection_link_hashes = jstruct_maps.map(&:to_jtext_jsection_link_hashes).compact.flatten
    jtext_jsection_links = build_jtext_jsection_links(jsections_hash, jtext_jsection_link_hashes, jtexts_hash)
    JtextJsectionLink.import jtext_jsection_links

    jarticles = extract_jarticles(path)
    puts "#{jarticles.length} jarticles extracted"
    Jarticle.import jarticles
    jarticles_hash = jarticles.reduce({}) { |h, jarticle| h[jarticle.id_jarticle_origin] = jarticle; h }

    jtext_jarticle_link_hashes = jstruct_maps.map(&:to_jtext_jarticle_link_hashes).compact.flatten
    jtext_jarticle_links = build_jtext_jarticle_links(jarticles_hash, jtext_jarticle_link_hashes, jtexts_hash)
    JtextJarticleLink.import jtext_jarticle_links

    jsection_article_link_hashes = jsections_maps.map(&:to_jscta_jarticle_link_hashes).compact.flatten
    jsection_jarticle_links = build_jsection_jarticle_links(jarticles_hash, jsection_article_link_hashes, jsections_hash)

    JsectionJarticleLink.import jsection_jarticle_links
  end

  def build_jtext_jarticle_links(jarticles_hash, jtext_jarticle_link_hashes, jtexts_hash)
    jtext_jarticle_link_hashes.map do |jtext_jarticle_link_hash|
      jtext_id = jtexts_hash[jtext_jarticle_link_hash[:id_jtext_origin]].id
      jarticle = jarticles_hash[jtext_jarticle_link_hash[:id_jarticle_origin]]
      if jarticle.nil?
        $stderr.puts "missing article ! #{jtext_jarticle_link_hash[:id_jarticle_origin]}"
        next
      end
      jarticle_id = jarticle.id
      order = jtext_jarticle_link_hash[:order]
      jtext_jarticle_link = JtextJarticleLink.where(jtext_id: jtext_id, jarticle_id: jarticle_id).first
      jtext_jarticle_link.destroy if jtext_jarticle_link
      JtextJarticleLink.new(jtext_id: jtext_id, jarticle_id: jarticle_id, order: order)
    end.compact
  end

  def build_jtext_jsection_links(jsections_hash, jtext_jsection_link_hashes, jtexts_hash)
    jtext_jsection_link_hashes.map do |jtext_jsection_link_hash|
      jtext_id = jtexts_hash[jtext_jsection_link_hash[:id_jtext_origin]].id
      jsection_id = jsections_hash[jtext_jsection_link_hash[:id_jsection_origin]].id
      order = jtext_jsection_link_hash[:order]
      jtext_jsection_link = JtextJsectionLink.where(jtext_id: jtext_id, jsection_id: jsection_id).first
      jtext_jsection_link.destroy if jtext_jsection_link
      JtextJsectionLink.new(jtext_id: jtext_id, jsection_id: jsection_id, order: order)
    end
  end

  def build_jsection_jarticle_links(jarticles_hash, jsection_article_link_hashes, jsections_hash)
    jsection_article_link_hashes.map do |jsection_article_link_hash|
      jsection_id = jsections_hash[jsection_article_link_hash[:id_jsection_origin]].id
      jarticle_id = jarticles_hash[jsection_article_link_hash[:id_jarticle_origin]].id
      number = jsection_article_link_hash[:number]
      jsection_jarticle_link = JsectionJarticleLink.where(jsection_id: jsection_id, jarticle_id: jarticle_id).first
      jsection_jarticle_link.destroy if jsection_jarticle_link
      JsectionJarticleLink.new(jsection_id: jsection_id, jarticle_id: jarticle_id, number: number)
    end
  end

  def extract_jarticles(path)
    jarticle_paths = extract_jarticle_xml_paths(path)
    better_map(jarticle_paths) do |path|
      JarticleMap.parse(File.read(path), single: true).to_jarticle
    end
  end
  
  def extract_jsection_maps(path)
    jsection_paths = extract_jsection_xml_paths(path)
    better_map(jsection_paths) do |path|
      JsctaMap.parse(File.read(path), single: true)
    end
  end

  def extract_jstruct_maps(path)
    jorftext_struct_paths = extract_struct_xml_paths(path)
    better_map(jorftext_struct_paths) do |jorftext_struct_path|
      JstructMap.parse(File.read(jorftext_struct_path), :single => true)
    end
  end

  def extract_jversion_maps(path)
    jorftext_version_paths = extract_version_xml_paths(path)
    better_map(jorftext_version_paths) do |jorftext_version_path|
      JversionMap.parse(File.read(jorftext_version_path), :single => true)
    end
  end

  def complete_jtexts_and_returns_keywords (jtexts, jversion_maps)
    keywords_map = {}
    jtexts_map = jtexts.reduce({}) { |hash, jtext| hash[jtext.id_jorftext_origin] = jtext; hash }

    jversion_maps.each do |jversion_map|
      jtext = jtexts_map[jversion_map.id_jtext_origin]
      if jtext
        jtext.title_full = jversion_map.title_full
        jtext.permanent_link = jversion_map.permanent_link
        keywords = jversion_map.keywords.map do |k|
          keywords_map[k] = k.to_keyword unless keywords_map.include?(k)
          keywords_map[k]
        end
        jtext.keywords << keywords
      else
        puts "No Jtext for #{jversion_map.id_jtext_origin}"
      end
    end
    keywords_map.values
  end

  def build_jtext_kewords(jtext_keword_hashes)
    jtext_keword_hashes.each do |jkh|
      jtext_keyword = JtextKeyword.where(jtext_id: jkh.jtext.id, keyword_id: jkh.keyword.id).first
      jtext_keyword.destroy if jtext_keyword
      JtextKeyword.new(jtext_id: jkh.jtext.id, keyword_id: jkh.keyword.id)
    end
  end

  def extract_jcont_maps(path)
    jorfcont_paths = extract_conteneur_xml_paths(path)
    better_map(jorfcont_paths) { |jorfcont_path| JorfcontMap.parse(File.read(jorfcont_path), :single => true) }
  end

  def build_jorfcont_jorftext_links(jorfcont_jorftext_link_hashes, jorfconts_hash, jorftexts_hash)
    jorfcont_jorftext_link_hashes.map do |jorfcont_jorftext_link_hash|
      id_jorfcont_origin = jorfcont_jorftext_link_hash[:id_jorfcont_origin]
      id_jorftext_origin = jorfcont_jorftext_link_hash[:id_jorftext_origin]

      jorfcont_id = jorfconts_hash[id_jorfcont_origin].id
      if jorftexts_hash[id_jorftext_origin]
        jorftext_id = jorftexts_hash[id_jorftext_origin].id
      else
        $stderr.puts "missing text ! #{id_jorftext_origin}"
        next
      end

      jorfcont_jtext_link = JorfcontJtextLink.where(jorfcont_id: jorfcont_id, jtext_id: jorftext_id).first
      jorfcont_jtext_link.destroy if jorfcont_jtext_link
      JorfcontJtextLink.new(jorfcont_id: jorfcont_id, jtext_id: jorftext_id, title: jorfcont_jorftext_link_hash[:title])
    end.compact
  end

  def better_map array, &block
    result = Parallel.map(array) { |el| block.call(el) }
    begin
      ActiveRecord::Base.connection.reconnect!
    rescue
      ActiveRecord::Base.connection.reconnect!
    end
    result
  end

end
