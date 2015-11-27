require './lib/logic/map/article_version_map'

class JorftextMap
  include HappyMapper
  tag 'TEXTELR'

  has_one :id_jorftext_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_one :nature, String, :xpath => 'META/META_COMMUN/NATURE'
  has_one :sequence_number, Integer, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/NUM_SEQUENCE'
  has_one :nor, String, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/NOR'
  has_one :publication_date, DateTime, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/DATE_PUBLI'
  has_one :text_date, DateTime, :xpath => 'META/META_SPEC/META_TEXTE_CHRONICLE/DATE_TEXTE'


  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

  def to_jorftext
     Jorftext.new(to_hash)
  end

end

