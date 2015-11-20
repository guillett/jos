require './lib/logic/map/section_map'
require './lib/logic/map/section_article_map'

class LegisctaMap
  include HappyMapper

  tag 'SECTION_TA'
  element :id, String, :xpath => 'ID'
  has_many :sections, SectionMap, :xpath => 'STRUCTURE_TA'
  has_many :articles, SectionArticleMap, :xpath => 'STRUCTURE_TA'

  def extract_linked_sections
    @sections.map.with_index do |sectionMap, i|
      section = Section.new(sectionMap.to_hash)
      section.order = i
      section.id_section_parent_origin = @id
      section
    end
  end

  def extract_articles article_maps
    @articles.map.with_index do |sectionArticleMap, i|
      article = Article.new(sectionArticleMap.to_hash)
      article.order = i

      article_map = article_maps.find{|a| a.id == article.id_article_origin }
      unless article_map.nil?
        article.nature = article_map.nature
        article.nota = article_map.nota
        article.text = article_map.text
        article.versions = article_map.extract_linked_versions
      end

      article
    end
  end

end