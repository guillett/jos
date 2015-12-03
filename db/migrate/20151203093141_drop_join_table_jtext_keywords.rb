class DropJoinTableJtextKeywords < ActiveRecord::Migration
  def change
    drop_join_table :jtexts, :keywords, table_name: 'jtext_keywords'
  end
end
