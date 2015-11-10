class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.int :level
      t.string :state
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
