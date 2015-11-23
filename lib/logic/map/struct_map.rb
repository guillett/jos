require './lib/logic/map/link_section_map'

class StructMap
  include HappyMapper
  tag 'TEXTELR'

  has_one :id_section_origin, String, :xpath => 'META/META_COMMUN/ID'
  has_many :section_links, LinkSectionMap, :xpath => 'STRUCT'

  # def extract_linked_sections
  #   @sections.map.with_index do |s, i|
  #     section = Section.new(s.to_hash)
  #     section.order = i
  #     section.id_section_parent_origin = @id
  #     section
  #   end
  # end

  def to_section_links_hash
    section_links.map.with_index do |sectionMap, i|
      h = sectionMap.to_hash
      h['order'] = i
      h['source_id_section_origin'] = @id_section_origin
      h
    end
  end

end