class AddJtextToJarticles < ActiveRecord::Migration
  def change
    add_reference :jarticles, :jtext, index: true, foreign_key: true
  end
end
