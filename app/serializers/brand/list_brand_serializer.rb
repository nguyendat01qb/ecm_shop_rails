class Brand::ListBrandSerializer < ActiveModel::Serializer
  attributes :id, :title, :product_quantity, :created_at, :updated_at

  def product_quantity
    object.products.count
  end

  def created_at
    object.created_at.strftime("%H:%M %d/%m/%Y")
  end

  def updated_at
    object.updated_at.strftime("%H:%M %d/%m/%Y")
  end
end