class V1::Customer::HomeController < V1::BaseController
  before_action :authenticate_user!, only: :get_product_cart

  def filter_products
    @products = Client::Home::FilterProductsService.call(params)

    html = render_to_string partial: 'home/shared/features_items', layout: false
    render json: { status: 200, message: 'Successfully', html: html }
  end

  def get_product_cart
    return render json: unauthorized_message(I18n.t('messages.error.missing_api_token')) if current_user.blank?
    cart = current_user.carts.is_pending.first
    if cart.blank? || cart.cart_items.blank?
      return render json: error_message(I18n.t('messages.warning.cart.empty_cart'))
    end
    product_id = cart.cart_items.pluck(:product_id).uniq
    number_of_items = product_id.length
    render json: success_message('OK', number_of_items: number_of_items)
  end
end
