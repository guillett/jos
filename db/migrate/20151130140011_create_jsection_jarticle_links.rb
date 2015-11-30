class CreateJsectionJarticleLinks < ActiveRecord::Migration
  def change
    create_join_table :jsections, :jarticles, table_name: 'jsection_jarticle_links' do |t|
      t.index [:jsection_id, :jarticle_id]
      t.integer :number
    end
  end
end
