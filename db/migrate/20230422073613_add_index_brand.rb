class AddIndexBrand < ActiveRecord::Migration[6.1]
  def change
    add_index :brands, :title, name: 'title_index_fulltext', type: :fulltext
  end
end
