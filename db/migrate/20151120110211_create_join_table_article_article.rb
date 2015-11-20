class CreateJoinTableArticleArticle < ActiveRecord::Migration
  def change
    create_table "article_versions", :force => true, :id => false do |t|
      t.integer "article_a_id", :null => false
      t.integer "article_b_id", :null => false
    end
  end
end
