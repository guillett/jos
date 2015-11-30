require 'nokogiri'
require './app/models/article'
require './app/models/section'
require './app/models/code'

class Extractor

  JORFTEXT_STRUCTURE_PATTERN = 'texte/struct/**/*.xml'
  JORFCONT_PATTERN = 'conteneur/**/*.xml'

  def extract_struct_xml_paths path
    Dir.glob(File.join(path, JORFTEXT_STRUCTURE_PATTERN))
  end

  def extract_conteneur_xml_paths path
    Dir.glob(File.join(path, JORFCONT_PATTERN))
  end

  def extract_jorf path
    jorfcont_paths = extract_conteneur_xml_paths(path)
    jorfcont_maps = jorfcont_paths.map do |jorfcont_path|
      JorfcontMap.parse(File.read(jorfcont_path), :single => true)
    end

    jorfconts = jorfcont_maps.map(&:to_jorfcont)
    jorfcont_jorftext_link_hashes = jorfcont_maps.map(&:to_jorfcont_jorftext_link_hashes).compact.flatten

    jorftext_struct_paths = extract_struct_xml_paths(path)
    jorftexts = jorftext_struct_paths.map do |jorftext_struct_path|
      JorftextMap.parse(File.read(jorftext_struct_path), :single => true).to_jorftext
    end

    Jorfcont.import jorfconts
    Jtext.import jorftexts

    jorfconts_hash = jorfconts.reduce({}) { |h, jorfcont| h[jorfcont.id_jorfcont_origin] = jorfcont; h }
    jorftexts_hash = jorftexts.reduce({}) { |h, jorftext| h[jorftext.id_jorftext_origin] = jorftext; h }

    jorfcont_jorftext_links = build_jorfcont_jorftext_links(jorfcont_jorftext_link_hashes, jorfconts_hash, jorftexts_hash)

    JorfcontJorftextLink.import jorfcont_jorftext_links

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
