class CreateJoinTableCodeSection < ActiveRecord::Migration
  def change
    create_table :code_section_links do |t|
      t.belongs_to :code, index: true
      t.belongs_to :section, index: true
      t.string :state
      t.integer :order
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps null: false
    end
  end
end
