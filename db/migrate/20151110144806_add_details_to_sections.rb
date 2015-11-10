class AddDetailsToSections < ActiveRecord::Migration
  def change
    add_column :sections, :id_section_origin, :string
    add_column :sections, :order, :integer
    add_column :sections, :id_section_parent_origin, :string
  end
end
