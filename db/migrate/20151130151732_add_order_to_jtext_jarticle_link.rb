class AddOrderToJtextJarticleLink < ActiveRecord::Migration
  def change
    add_column :jtext_jarticle_links, :order, :integer
  end
end
