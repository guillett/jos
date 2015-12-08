class CreateJoinTableKeywordsUser < ActiveRecord::Migration
  def change
    create_join_table :users, :keywords do |t|
      t.index :user_id
      t.index :keyword_id
    end
  end
end
