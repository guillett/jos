class AddTitleToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :number, :string
  end
end
