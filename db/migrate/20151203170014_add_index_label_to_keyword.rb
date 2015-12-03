class AddIndexLabelToKeyword < ActiveRecord::Migration
  def change
    add_index :keywords, :label, unique: false
  end
end
