class AddNatureToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :nature, :string
  end
end
