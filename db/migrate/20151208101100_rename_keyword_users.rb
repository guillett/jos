class RenameKeywordUsers < ActiveRecord::Migration
  def self.up
    rename_table :keywords_users, :user_keywords
  end

  def self.down
    rename_table :user_keywords, :keywords_users
  end
end