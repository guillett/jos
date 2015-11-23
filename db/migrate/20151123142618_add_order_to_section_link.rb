class AddOrderToSectionLink < ActiveRecord::Migration
  def change
    add_column :section_links, :order, :integer
  end
end
