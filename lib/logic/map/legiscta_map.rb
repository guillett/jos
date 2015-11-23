require './lib/logic/map/link_section_map'
require './lib/logic/map/link_article_section_map'

class LegisctaMap
  include HappyMapper

  tag 'SECTION_TA'
  element :id_section_origin, String, :xpath => 'ID'
  element :title, String, :xpath => 'TITRE_TA'

  has_many :section_links, LinkSectionMap, :xpath => 'STRUCTURE_TA'
  has_many :article_links, LinkSectionArticleMap, :xpath => 'STRUCTURE_TA'

  def to_section
    Section.new(id_section_origin: id_section_origin, title: title)
  end

  def to_section_links_hash
    section_links.map.with_index do |sectionMap, i|
      h = sectionMap.to_hash
      h['order'] = i
      h['source_id_section_origin'] = @id_section_origin
      h
    end
  end

  def to_article_links_hash
    @article_links.map.with_index do |linkArticleSectionMap, i|
      h = linkArticleSectionMap.to_hash
      h['order'] = i
      h['source_id_section_origin'] = @id_section_origin
      h
    end
  end

end