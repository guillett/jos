require './lib/logic/map/jorf/link_jtext_jarticle_map'
require './lib/logic/map/jorf/link_jtext_jsection_map'

class JstructMap
  include HappyMapper
  tag 'TEXTELR'

  has_one :id_jorftext_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_one :nature, String, :xpath => 'META/META_COMMUN/NATURE'
  has_one :sequence_number, Integer, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/NUM_SEQUENCE'
  has_one :nor, String, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/NOR'
  has_one :publication_date, DateTime, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/DATE_PUBLI'
  has_one :text_date, DateTime, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/DATE_TEXTE'

  has_many :link_text_article_maps, LinkJtextJarticleMap, :xpath => 'STRUCT'
  has_many :link_text_section_maps, LinkJtextJsectionMap, :xpath => 'STRUCT'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash.delete("link_text_article_maps")
    hash.delete("link_text_section_maps")
    hash
  end

  def to_jtext
    Jtext.new(to_hash)
  end

  def to_jtext_update
    jtext = Jtext.where(id_jorftext_origin: @id_jorftext_origin).first
    jtext.destroy if jtext
    Jtext.new(to_hash)
  end

  def to_jtext_jarticle_link_hashes
    link_text_article_maps.map { |lta| { id_jtext_origin: id_jorftext_origin, id_jarticle_origin: lta.id_jarticle_origin, order: lta.number }}
  end

  def to_jtext_jsection_link_hashes
    link_text_section_maps.map.with_index do |lts, i|
      { id_jtext_origin: id_jorftext_origin, id_jsection_origin: lts.id_jsection_origin, order: i }
    end
  end

end

