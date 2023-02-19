class AddTotalOnlineTimeToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :total_online_time, :float
  end
end
