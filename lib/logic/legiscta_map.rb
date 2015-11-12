require './lib/logic/section_map'

class LegisctaMap
  include HappyMapper
  tag 'SECTION_TA'

  has_many :sections, SectionMap, :xpath => 'STRUCTURE_TA'
end