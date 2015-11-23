class RemoveOrderFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :order, :integer
  end
end
