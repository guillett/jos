class CreateJorfconts < ActiveRecord::Migration
  def change
    create_table :jorfconts do |t|
      t.string :id_jorfcont_origin
      t.string :nature
      t.string :title
      t.integer :number
      t.datetime :publication_date

      t.timestamps null: false
    end
  end
end
