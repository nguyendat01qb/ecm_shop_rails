class Product::FilterProductsSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :discount, :quantity

  def price
    return unless object.price
    object.price.to_f.round(2)
  end

  def discount
    return unless object.discount
    (object.price.to_i * object.discount).round(2)
  end
end
