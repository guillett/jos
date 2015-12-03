class AddOrderToHistoryLinks < ActiveRecord::Migration
  def change
    add_column :history_links, :order, :integer
  end
end
