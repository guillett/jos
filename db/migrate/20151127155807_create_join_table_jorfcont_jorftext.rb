class CreateJoinTableJorfcontJorftext < ActiveRecord::Migration
  def change
    create_join_table :jorfconts, :jorftexts, table_name: 'jorfcont_jorftext_links' do |t|
      t.index [:jorfcont_id, :jorftext_id]
    end
  end
end
