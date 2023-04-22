class AddIndexVoucher < ActiveRecord::Migration[6.1]
  def change
    add_index :vouchers, :name, name: 'name_index_fulltext', type: :fulltext
  end
end
