class AddEscapeTitleToCodes < ActiveRecord::Migration
  def change
    add_column :codes, :escape_title, :string
  end
end
