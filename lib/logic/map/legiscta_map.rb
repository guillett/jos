require './lib/logic/map/section_map'
require './lib/logic/map/section_article_map'

class LegisctaMap
  include HappyMapper

  tag 'SECTION_TA'
  element :id_section_origin, String, :xpath => 'ID'
  element :title, String, :xpath => 'TITRE_TA'

  has_many :section_links, SectionMap, :xpath => 'STRUCTURE_TA'
  has_many :article_links, SectionArticleMap, :xpath => 'STRUCTURE_TA'


  def extract_articles article_maps
    @article_links.map.with_index do |sectionArticleMap, i|
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

  def to_section
    Section.new(id_section_origin: id_section_origin, title: title)
  end

  def to_section_links_hash
    section_links.map.with_index do |sectionMap, i|
      h = sectionMap.to_hash
      h['order'] = i
      h['source_id_origin'] = @id_section_origin
      h
    end
  end

end