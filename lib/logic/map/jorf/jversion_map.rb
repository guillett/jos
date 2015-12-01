require './lib/logic/map/jorf/keyword_map'

class JversionMap
  include HappyMapper
  tag 'TEXTE_VERSION'

  has_one :id_jtext_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_one :permanent_link, String, :xpath => 'META/META_COMMUN/ID_ELI'
  has_one :title_full, String, :xpath => 'META/META_SPEC/META_TEXTE_VERSION/TITREFULL'
  has_many :keywords, KeywordMap, :xpath => 'META/META_SPEC/META_TEXTE_VERSION/MCS_TXT'

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete("@")] = instance_variable_get(var) }
    hash
  end

end