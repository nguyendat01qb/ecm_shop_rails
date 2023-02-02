class Product::ProductDetailSerializer < ActiveModel::Serializer
  attributes :id, :price, :discount, :quantity

  def price
    return 0 unless object.price_attribute_product
    object.price_attribute_product
  end

  def discount
    return 0 unless object.discount_attribute_product
    object.price_attribute_product * (1 - object.discount_attribute_product)
  end

  def quantity
    object.stock? ? object.stock : 0
  end
end