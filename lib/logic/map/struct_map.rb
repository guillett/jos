class StructMap
  include HappyMapper
  tag 'TEXTELR'

  has_one :ID, String, :xpath => 'META/META_COMMUN/ID'
  has_many :sections, SectionMap, :xpath => 'STRUCT'
end