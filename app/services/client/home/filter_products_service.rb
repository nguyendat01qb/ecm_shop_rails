class Client::Home::FilterProductsService < ApplicationService
  def initialize(args)
    @brand_id = args[:brand_id].to_i
    @category_id = args[:category_id].to_i
  end

  def call
    if brand_id.zero?
      load_by_category
    elsif category_id.zero?
      Product.where(brand_id: brand_id).with_attached_images
    else
      products = load_by_category
      products.map do |product|
        product if product.brand_id == brand_id
      end
    end
  end

  private

  attr_reader :brand_id, :category_id

  def load_by_category
    category = Category.friendly.find_by(id: category_id)
    childs = category.childs

    products = []
    if childs.present?
      childs.each do |item|
        products.concat(item.products.with_attached_images)
      end
    else
      products = category.products.with_attached_images
    end
    products
  end
end
