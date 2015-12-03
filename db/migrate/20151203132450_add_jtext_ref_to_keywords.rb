class AddJtextRefToKeywords < ActiveRecord::Migration
  def change
    add_reference :keywords, :jtext, index: true, foreign_key: true
  end
end
