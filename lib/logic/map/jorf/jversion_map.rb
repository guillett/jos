require './lib/logic/map/jorf/keyword_map'

class JversionMap
  include HappyMapper
  tag 'TEXTE_VERSION'

  has_one :id_jtext_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_many :keywords, KeywordMap, :xpath => 'META/META_SPEC/META_TEXTE_VERSION/MCS_TXT'

  def to_keywords_hash
    keywords.map do |keywordMap|
      keywordMap.to_hash
    end
  end

end