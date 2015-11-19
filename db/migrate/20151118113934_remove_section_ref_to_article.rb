class RemoveSectionRefToArticle < ActiveRecord::Migration
  def change
    remove_reference :articles, :section
  end
end
