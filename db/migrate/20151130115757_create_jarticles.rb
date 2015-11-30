class CreateJarticles < ActiveRecord::Migration
  def change
    create_table :jarticles do |t|
      t.string :id_jarticle_origin
      t.text :text

      t.timestamps null: false
    end
  end
end
