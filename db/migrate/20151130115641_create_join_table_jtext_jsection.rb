class CreateJoinTableJtextJsection < ActiveRecord::Migration
  def change
    create_join_table :jtexts, :jsections, table_name: 'jtext_jsection_links' do |t|
      t.index [:jtext_id, :jsection_id]
    end
  end
end
