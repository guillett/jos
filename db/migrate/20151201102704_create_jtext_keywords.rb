class CreateJtextKeywords < ActiveRecord::Migration
  def change
    create_table :jtext_keywords do |t|
      t.references :jtext, index: true, null: false, foreign_key: true
      t.references :keyword, index: true, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end
