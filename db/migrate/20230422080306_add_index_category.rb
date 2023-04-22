class AddIndexCategory < ActiveRecord::Migration[6.1]
  def change
    add_index :categories, :title, name: 'title_index_fulltext', type: :fulltext
  end
end
