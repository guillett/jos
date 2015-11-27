class CreateJorftexts < ActiveRecord::Migration
  def change
    create_table :jorftexts do |t|
      t.string :id_jorftext_origin
      t.string :nature
      t.integer :sequence_number
      t.string :nor
      t.datetime :publication_date
      t.datetime :text_date

      t.timestamps null: false
    end
  end
end
