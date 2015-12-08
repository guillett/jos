class CreateKeywordUsers < ActiveRecord::Migration
  def change
    create_table :keyword_users do |t|

      t.timestamps null: false
    end
  end
end
