class V1::Customer::ProductsController < V1::BaseController
  # before_action :authenticate_user, only: :select_attribute

  def search
    @products = Product.query_search(:title, params[:search]).order(created_at: :desc)

    html = render_to_string partial: 'home/shared/features_items', layout: false
    render json: { status: 200, message: 'Successfully', html: html }
  end

  def load_more
    page = (params[:page] || 1).to_i
    per_page = params[:per_page] || Product::PER_PAGE
    products = Product.all.page(page).per(per_page)
    total_pages = products.total_pages

    if (page >= 1) && (page <= total_pages)
      offset = page.to_i * Product::PER_PAGE
      @products = Product.limit(Product::PER_PAGE).offset(offset)
      html = render_to_string partial: 'home/shared/list_products', layout: false

      next_page = page + 1 == total_pages ? 'last_page' : ''
    else
      next_page = 'error_page'
    end

    render json: { status: 200, message: 'Successfully', html: html, page: next_page }
  end

  def select_attribute
    product_attribute = ProductAttribute.includes(:attribute_values).find_by(id: params[:id_attr1])
    attribute_values = product_attribute.attribute_values

    attribute_value =
      if params[:id_attr2].nil?
        attribute_values.find_by(attribute_1: params[:value_attr1], attribute_2: nil)
      else
        attribute_values.where(attribute_1: params[:value_attr1]).find_by(attribute_2: params[:value_attr2])
      end

    render json: success_message(
      I18n.t('messages.success.product.attributes'),
      attribute_value: ActiveModelSerializers::SerializableResource.new(
        attribute_value,
        each_serializer: Product::ProductDetailSerializer
      )
    )
  end

  def add_to_cart
    return render json: error_message(I18n.t('messages.warning.cart.empty_cart')) unless current_user

    cart = current_user.carts.is_pending.first
    cart ||= current.carts.create!(status: Cart::STATUSES[:pending])
    params = request.params
    product_id = request.params[:product_id].to_i
    attr_value_id = AttributeValue.find_by(attribute_1: params[:value_attr1], attribute_2: params[:value_attr2]).id
    if cart.cart_items.pluck(:product_id, :attribute_value_id).include?([product_id, attr_value_id])
      cart_item = cart.cart_items.find_by(product_id: product_id, attribute_value_id: attr_value_id)
      quantity = cart_item.quantity + params[:quantity].to_i
      cart_item.update!(quantity: quantity)
    else
      cart_item = cart.cart_items.create!(product_id: product_id, attribute_value_id: attr_value_id,
                                          quantity: params[:quantity])
    end
    render json: success_message(
      I18n.t('messages.success.product.add_cart'),
      cart_item: cart_item
    )
  end
end
