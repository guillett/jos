class RemoveDetailsFromSection < ActiveRecord::Migration
  def change
    remove_column :sections, :level, :integer
    remove_column :sections, :state, :String
    remove_column :sections, :start_date, :datetime
    remove_column :sections, :end_date, :datetime
    remove_column :sections, :order, :integer
    remove_column :sections, :id_section_parent_origin, :string
  end
end
