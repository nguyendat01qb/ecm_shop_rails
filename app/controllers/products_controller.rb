class ProductsController < ApplicationController
  def show
    @categories = Category.is_parent.include_categories
    @brands = Brand.all.include_products
    @product_id = params[:id]
    @signed_in = cookies[:api_token].present?
  end
end
