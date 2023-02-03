class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user

  def show
    if params[:carts].nil? && cookies[:add_to_cart].nil?
      render :show
    elsif params[:carts]
      @cart = exists_product?(params[:carts].values)

      html = render_to_string partial: 'cart/shared/list_product_cart', layout: false
      render json: { status: 200, html: html, carts: params[:carts].values }
    else
      @cart = exists_product?(JSON.parse(cookies[:add_to_cart]))

      cart = JSON.parse(cookies[:add_to_cart])
      ids = cart.map { |el| el['id'] }
      @products = Product.where(id: ids)
    end
  end

  def check_amount
    product = Product.find_by(id: params[:cart][:id])

    if params[:cart][:id_attr1].present? && params[:cart][:id_attr2].nil?
      data = ProductAttribute.find_by(id: params[:cart][:id_attr1]).attribute_values.find_by(attribute_1: params[:cart][:value_attr1])
    elsif params[:cart][:id_attr1].present? && params[:cart][:id_attr2].present?
      data = ProductAttribute.find_by(id: params[:cart][:id_attr1]).attribute_values.where(attribute_1: params[:cart][:value_attr1]).find_by(attribute_2: params[:cart][:value_attr2])
    end

    render json: { status: 200, message: 'Successfully', data: data, product: product }
  end

  private

  def exists_product?(cart)
    ids = cart.map { |item| item['id'].to_i }.uniq
    products = Product.where(id: ids).group_by(&:id).keys
    cart.select { |el| products.include?(el['id'].to_i) }
  end
end
