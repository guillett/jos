class AddIndexIdJarticleOriginToJarticle < ActiveRecord::Migration
  def change
    add_index :jarticles, :id_jarticle_origin, unique: true
  end
end
