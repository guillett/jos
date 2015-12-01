class AddDetailsToJtext < ActiveRecord::Migration
  def change
    add_column :jtexts, :title_full, :string
    add_column :jtexts, :permanent_link, :string
  end
end
