class AttributeValue < ApplicationRecord
  has_many :product_attribute_values
  has_many :product_attributes, through: :product_attribute_values
  has_many :cart_items

  validates :attribute_1, presence: true
  validates :price_attribute_product, presence: true, allow_blank: false
  validates :stock, presence: true, allow_blank: false
end
