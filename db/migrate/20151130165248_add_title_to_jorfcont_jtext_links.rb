class AddTitleToJorfcontJtextLinks < ActiveRecord::Migration
  def change
    add_column :jorfcont_jtext_links, :title, :string
  end
end
