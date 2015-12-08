class DropTableKeywordUsers < ActiveRecord::Migration
  def change
    drop_table :keyword_users
  end
end
