class AddStatusToUserVoucher < ActiveRecord::Migration[6.1]
  def change
    add_column :user_vouchers, :status, :integer, default: 0
  end
end
