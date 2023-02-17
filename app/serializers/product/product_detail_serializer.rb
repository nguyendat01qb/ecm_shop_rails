class Product::ProductDetailSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :discount, :quantity, :brand, :categories

  def price
    return unless object.price
    object.price.to_f.round(2)
  end

  def discount
    return unless object.discount
    (object.price.to_f * object.discount).round(2)
  end

  def brand
    return unless object.brand
    object.brand.title
  end

  def categories
    return if object.categories.blank?
    object.categories.map(&:title)
  end
end
