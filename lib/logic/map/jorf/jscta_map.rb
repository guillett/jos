require './lib/logic/map/jorf/link_jsection_jarticle_map'
require './lib/logic/map/jorf/link_jsection_map'

class JsctaMap
  include HappyMapper
  tag 'SECTION_TA'

  has_one :id_jsection_origin, String, :xpath => 'ID'
  has_one :title, String, :xpath => 'TITRE_TA'

  has_many :link_section_article_maps, LinkJsectionJarticleMap, :xpath => 'STRUCTURE_TA'
  has_many :link_section_maps, LinkJsectionMap, :xpath => 'STRUCTURE_TA'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash.delete("link_section_article_maps")
    hash.delete("link_section_maps")
    hash
  end

  def to_jsection
    Jsection.new(to_hash)
  end

  def to_jsection_update
    jsection = Jsection.where(id_jsection_origin: @id_jsection_origin).first
    jsection.destroy if jsection
    Jsection.new(to_hash)
  end

  def to_jscta_jarticle_link_hashes
    link_section_article_maps.map { |lsa| { id_jsection_origin: id_jsection_origin, id_jarticle_origin: lsa.id_jarticle_origin, number: lsa.number }}
  end

end