class Article < ActiveRecord::Base
  has_and_belongs_to_many :section

  has_and_belongs_to_many(:versions,
                          :class_name => "Article",
                          :join_table => "article_versions",
                          :foreign_key => "article_a_id",
                          :association_foreign_key => "article_b_id")
end
