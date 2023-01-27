class Client::Home::ProductsCategoryService < ApplicationService
  def initialize(slug)
    @slug = slug
  end

  def call
    category = Category.friendly.find_by(slug: slug)
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

  private

  attr_accessor :slug
end
