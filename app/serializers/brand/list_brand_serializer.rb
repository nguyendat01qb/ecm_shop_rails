class Brand::ListBrandSerializer < ActiveModel::Serializer
  attributes :id, :title, :product_quantity

  def product_quantity
    object.products.count
  end
end
