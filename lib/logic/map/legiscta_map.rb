require './lib/logic/map/section_map'

class LegisctaMap
  include HappyMapper

  tag 'SECTION_TA'
  element :id, String, :xpath => 'ID'
  has_many :sections, SectionMap, :xpath => 'STRUCTURE_TA'
end