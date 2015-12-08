class AddNumberToJarticle < ActiveRecord::Migration
  def change
    add_column :jarticles, :number, :integer
  end
end
