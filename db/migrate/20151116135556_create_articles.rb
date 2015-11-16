class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :id_article_origin
      t.string :state
      t.datetime :start_date
      t.datetime :end_date
      t.string :nota
      t.string :text

      t.timestamps null: false
    end
  end
end
