class Product::ListProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :price, :discount, :quantity, :price_cents, :show_home, :brand, :categories, :created_at

  def price
    return unless object.price
    object.price.format
  end

  def discount
    return unless object.discount
    "#{(object.discount * 100).round(2)} %"
  end

  def show_home
    return true if object.product_type == Product::TYPES[:show]
    false
  end

  def brand
    return unless object.brand
    object.brand.title
  end

  def categories
    return if object.categories.blank?
    object.categories.map(&:title)
  end

  def created_at
    object.created_at.strftime("%H:%M %d/%m/%Y")
  end
end