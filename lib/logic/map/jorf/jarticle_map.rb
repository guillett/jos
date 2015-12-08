require './lib/logic/map/jorf/link_jsection_jarticle_map'

class JarticleMap
  include HappyMapper
  tag 'ARTICLE'

  has_one :id_jarticle_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_one :text, String, :xpath => 'BLOC_TEXTUEL/CONTENU'
  has_one :number, Integer, :xpath => 'META/META_SPEC/META_ARTICLE/NUM'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

  def to_jarticle
    Jarticle.new(to_hash)
  end

  def to_jarticle_update
    jarticle = Jarticle.where(id_jarticle_origin: @id_jarticle_origin).first
    jarticle.destroy if jarticle
    Jarticle.new(to_hash)
  end
end