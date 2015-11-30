class CreateJoinTableJorfcontJtext < ActiveRecord::Migration
  def change
    create_join_table :jorfconts, :jtexts, table_name: 'jorfcont_jtext_links' do |t|
      t.index [:jorfcont_id, :jtext_id]
    end
  end
end
