class CreateSectionLinks < ActiveRecord::Migration
  def change
    create_table :section_links do |t|
      t.string :state
      t.datetime :start_date
      t.datetime :end_date

      t.column "source_id",  :integer, :null => false, foreign_key: true
      t.column "target_id", :integer, :null => false, foreign_key: true

      t.timestamps null: false
    end

    add_foreign_key :section_links, :sections, column: :source_id
    add_foreign_key :section_links, :sections, column: :target_id

  end
end
