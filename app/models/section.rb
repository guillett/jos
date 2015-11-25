class Section < ActiveRecord::Base
  belongs_to :code
  has_and_belongs_to_many :articles

  has_many :section_links, foreign_key: :source_id
  has_many :section_links_valid, -> { where(state:  ["VIGUEUR", "ABROGE_DIFF"]).order(:order) }, foreign_key: :source_id, class_name: "SectionLink"

  has_many :section_article_links
  has_many :section_article_links_valid, -> { where(state:  ["VIGUEUR", "ABROGE_DIFF"]).order(:order) }, foreign_key: :section_id, class_name: "SectionArticleLink"

  attr_accessor :section_links_preloaded
  attr_accessor :section_article_links_preloaded

  after_initialize do
    @section_links_preloaded=[]
    @section_article_links_preloaded=[]
  end

end
