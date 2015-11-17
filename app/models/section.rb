class Section < ActiveRecord::Base
  belongs_to :code
  has_many :articles, :dependent => :delete_all

  attr_accessor :sections

  after_initialize do
    @sections=[]
  end

  def summary
    hash = {}

    articles_vigueur = articles.where(state: 'VIGUEUR')
       .sort_by { |a| a.order }
       .each { |a| hash[a.id_article_origin] = a }

    articles_vigueur
  end

end
