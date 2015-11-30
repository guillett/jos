class DropJoinTableJorfcontJorftext < ActiveRecord::Migration
  def change
    drop_join_table :jorfconts, :jorftexts, table_name: 'jorfcont_jorftext_links'
  end
end
