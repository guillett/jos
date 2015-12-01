class CreateHistoryLinks < ActiveRecord::Migration
  def change
    create_table :history_links do |t|
      t.string :id_text_origin
      t.string :nature
      t.string :text_number
      t.string :text_type
      t.string :title
      t.references :article, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
