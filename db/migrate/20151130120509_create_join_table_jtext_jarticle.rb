class CreateJoinTableJtextJarticle < ActiveRecord::Migration
  def change
    create_join_table :jtexts, :jarticles, table_name: 'jtext_jarticle_links' do |t|
      t.index [:jtext_id, :jarticle_id]
    end
  end
end
