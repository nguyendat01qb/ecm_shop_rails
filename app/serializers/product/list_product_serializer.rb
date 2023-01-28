class Product::ListProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :discount, :quantity, :price_cents, :brand, :categories, :created_at

  def brand
    return unless object.brand
    object.brand.title
  end

  def price
    return unless object.price
    object.price.format
  end

  def discount
    return unless object.discount
    "#{(object.discount * 100).round(2)} %"
  end

  def categories
    return if object.categories.blank?
    object.categories.map(&:title)
  end

  def created_at
    object.created_at.strftime("%H:%M %d/%m/%Y")
  end
end