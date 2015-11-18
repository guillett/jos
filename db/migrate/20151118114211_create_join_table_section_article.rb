class CreateJoinTableSectionArticle < ActiveRecord::Migration
  def change
    create_join_table :sections, :articles do |t|
       t.index [:section_id, :article_id]
    end
  end
end
