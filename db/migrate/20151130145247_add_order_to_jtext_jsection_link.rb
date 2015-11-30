class AddOrderToJtextJsectionLink < ActiveRecord::Migration
  def change
    add_column :jtext_jsection_links, :order, :integer
  end
end
