require './lib/logic/map/section_map'

class StructMap
  include HappyMapper
  tag 'TEXTELR'

  has_one :id, String, :xpath => 'META/META_COMMUN/ID'
  has_many :sections, SectionMap, :xpath => 'STRUCT'

  def extract_linked_sections
    @sections.map.with_index do |s, i|
      section = Section.new(s.to_hash)
      section.order = i
      section.id_section_parent_origin = @id
      section
    end
  end

end