class AddIndexUser < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :name, name: 'name_index_fulltext', type: :fulltext
  end
end
