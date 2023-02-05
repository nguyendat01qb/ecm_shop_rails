class V1::Customer::CartsController < V1::BaseController
  def get_all
    if current_user && current_user.carts.is_pending.first
      cart = current_user&.carts.is_pending.first
      products_cart = cart.cart_items.map do |cart_item|
        product = cart_item.product
        images = product.images.map { |img| ({image: url_for(img)}) }.map(&:values).flatten
        attr_value = cart_item.attribute_value
        pa_name = attr_value.product_attributes.pluck(:name).compact
        pa_value = [attr_value.attribute_1, attr_value.attribute_2].compact
        quantity = cart_item.quantity
        price = attr_value.price_attribute_product
        discount = attr_value.discount_attribute_product * 100
        {
          product: product,
          pro_images: images,
          name: pa_name,
          id: cart_item.id,
          quantity: quantity,
          price: price,
          discount: discount,
          stock: attr_value.stock,
          attribute_value: pa_value,
          attr_id: attr_value.id
        }
      end
      render json: success_message(
        I18n.t('messages.success.cart.list_carts'),
        products_cart: products_cart
      )
    else
      if request.params[:cart].blank?
        render json: error_message(I18n.t('messages.warning.cart.empty_cart'))
      else
        products_cart = product_values(request)
        render json: success_message(
          I18n.t('messages.success.cart.list_carts'),
          products_cart: products_cart
        )
      end
    end
  end

  private

  def product_values(request)
    products = {}
    request.params[:cart].each do |key, val|
      if products.keys.include?(val[:product_id])
        products[val[:product_id]].push({attr_id: val[:attr_val_id], amount: val[:amount]})
      else
        products[val[:product_id]] = [{attr_id: val[:attr_val_id], amount: val[:amount]}]
      end
    end
    products.map do |product_id, attr_value|
      product = Product.find_by(id: product_id)
      images = product.images.map { |img| ({image: url_for(img)}) }.map(&:values).flatten
      attr_value.map do |attr_val|
        av = AttributeValue.find_by(id: attr_val[:attr_id])
        pa_name = av.product_attributes.pluck(:name)
        pa_value = [av.attribute_1, av.attribute_2].compact
        {
          product: product,
          pro_images: images,
          name: pa_name,
          quantity: attr_val[:amount].to_i,
          id: '',
          price: av.price_attribute_product,
          discount: av.discount_attribute_product * 100,
          stock: av.stock,
          attribute_value: pa_value,
          attr_id: av.id
        }
      end
    end.flatten
  end
end
