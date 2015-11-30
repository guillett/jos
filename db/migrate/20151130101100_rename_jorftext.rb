class RenameJorftext < ActiveRecord::Migration
  def self.up
    rename_table :jorftexts, :jtexts
  end

  def self.down
    rename_table :jtexts, :jorftexts
  end
end