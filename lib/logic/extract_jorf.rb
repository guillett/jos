require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'

class Extractor

  JTEXT_STRUCTURE_PATTERN = 'texte/struct/**/*.xml'
  JCONT_PATTERN = 'conteneur/**/*.xml'
  JSECTION_PATTERN = 'section_ta/**/*.xml'
  JARTICLE_PATTERN = 'article/**/*.xml'

  def extract_struct_xml_paths path
    Dir.glob(File.join(path, JTEXT_STRUCTURE_PATTERN))
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
    jconts = jcont_maps.map(&:to_jorfcont)
    jcont_jtext_link_hashes = jcont_maps.map(&:to_jorfcont_jorftext_link_hashes).compact.flatten

    jorftexts = extract_jtext_maps(path)

    Jorfcont.import jconts
    Jtext.import jorftexts

    jorfconts_hash = jconts.reduce({}) { |h, jorfcont| h[jorfcont.id_jorfcont_origin] = jorfcont; h }
    jorftexts_hash = jorftexts.reduce({}) { |h, jorftext| h[jorftext.id_jorftext_origin] = jorftext; h }

    jorfcont_jorftext_links = build_jorfcont_jorftext_links(jcont_jtext_link_hashes, jorfconts_hash, jorftexts_hash)

    JorfcontJorftextLink.import jorfcont_jorftext_links

    jsections_maps = extract_jsection_maps(path)
    jsections = jsections_maps.map(&:to_jsection)
    Jsection.import jsections

    jarticles = extract_jarticles(path)
    Jarticle.import jarticles

    jsections_hash = jsections.reduce({}) { |h, jsection| h[jsection.id_jsection_origin] = jsection; h }
    jarticles_hash = jarticles.reduce({}) { |h, jarticle| h[jarticle.id_jarticle_origin] = jarticle; h }

    jsection_article_link_hashes = jsections_maps.map(&:to_jscta_jarticle_link_hashes).compact.flatten
    jsection_jarticle_links = build_jsection_jarticle_links(jarticles_hash, jsection_article_link_hashes, jsections_hash)

    JsectionJarticleLink.import jsection_jarticle_links
  end

  def build_jsection_jarticle_links(jarticles_hash, jsection_article_link_hashes, jsections_hash)
    jsection_article_link_hashes.map do |jsection_article_link_hash|
      jsection_id = jsections_hash[jsection_article_link_hash[:id_jsection_origin]].id
      jarticle_id = jarticles_hash[jsection_article_link_hash[:id_jarticle_origin]].id
      number = jsection_article_link_hash[:number]
      JsectionJarticleLink.new(jsection_id: jsection_id, jarticle_id: jarticle_id, number: number)
    end
  end

  def extract_jarticles(path)
    jarticle_paths = extract_jarticle_xml_paths(path)
    jarticle_paths.map do |path|
      JarticleMap.parse(File.read(path), single: true).to_jarticle
    end
  end
  
  def extract_jsection_maps(path)
    jsection_paths = extract_jsection_xml_paths(path)
    jsection_paths.map do |path|
      JsctaMap.parse(File.read(path), single: true)
    end
  end

  def extract_jtext_maps(path)
    jorftext_struct_paths = extract_struct_xml_paths(path)
    jorftexts = jorftext_struct_paths.map do |jorftext_struct_path|
      JtextMap.parse(File.read(jorftext_struct_path), :single => true).to_jtext
    end
  end

  def extract_jcont_maps(path)
    jorfcont_paths = extract_conteneur_xml_paths(path)
    jorfcont_paths.map { |jorfcont_path| JorfcontMap.parse(File.read(jorfcont_path), :single => true) }
  end

  def build_jorfcont_jorftext_links(jorfcont_jorftext_link_hashes, jorfconts_hash, jorftexts_hash)
    jorfcont_jorftext_link_hashes.map do |jorfcont_jorftext_link_hash|
      id_jorfcont_origin = jorfcont_jorftext_link_hash[:id_jorfcont_origin]
      id_jorftext_origin = jorfcont_jorftext_link_hash[:id_jorftext_origin]

      jorfcont_id = jorfconts_hash[id_jorfcont_origin].id
      jorftext_id = jorftexts_hash[id_jorftext_origin].id

      JorfcontJorftextLink.new(jorfcont_id: jorfcont_id, jorftext_id: jorftext_id)
    end
  end

end
