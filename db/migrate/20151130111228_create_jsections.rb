class CreateJsections < ActiveRecord::Migration
  def change
    create_table :jsections do |t|
      t.string :id_jsection_origin
      t.string :title

      t.timestamps null: false
    end
  end
end
