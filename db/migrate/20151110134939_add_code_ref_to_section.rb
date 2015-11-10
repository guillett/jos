class AddCodeRefToSection < ActiveRecord::Migration
  def change
    add_reference :sections, :code, index: true, foreign_key: true
  end
end
