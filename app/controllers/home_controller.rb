class HomeController < ApplicationController
  def index
    @categories = Category.is_parent.include_categories
    @brands = Brand.all.include_products

    if params[:category].nil? && params[:brand].nil? && params[:page].nil? && params[:search].nil?
      @products = Product.with_attached_images.includes(:product_attributes).limit(Product::PER_PAGE)
    elsif params[:category].present?
      @products = Client::Home::ProductsCategoryService.call(params[:category])
    elsif params[:brand].present?
      @products = Client::Home::ProductsBrandService.call(params[:brand])
    elsif params[:page].present?
      @products, @status = Client::Home::LoadMoreService.call(params[:page])
    elsif params[:search].present?
      @product = Product.query_search(:title, params[:search]).order(created_at: :desc)
    end
  end
end
