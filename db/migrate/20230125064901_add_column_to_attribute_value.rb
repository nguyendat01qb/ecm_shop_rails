class AddColumnToAttributeValue < ActiveRecord::Migration[6.1]
  def change
    add_column :attribute_values, :discount_attribute_product, :float
  end
end
