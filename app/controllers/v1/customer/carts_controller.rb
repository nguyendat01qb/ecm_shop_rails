class V1::Customer::CartsController < V1::BaseController
  def get_all
    if current_user
      cart = current_user&.carts&.is_pending&.first
      if cart.blank?
        cart = current_user.carts.create!(status: Cart::STATUSES[:pending])
        request.params[:cart].each_line do |cart_item|
          product_id = cart_item[:product_id].to_i
          quantity = cart_item[:amount].to_i
          attr_id = cart_item[:attr_val_id].to_i
          cart.cart_items.create!(product_id: product_id, attribute_value_id: attr_id, quantity: quantity)
        end
      end
      product_values(cart)
    elsif request.params[:cart].blank?
      render json: error_message(I18n.t('messages.warning.cart.empty_cart'))
    else
      products = {}
      request.params[:cart].each do |_key, val|
        if products.keys.include?(val[:product_id])
          products[val[:product_id]].push({ attr_id: val[:attr_val_id], amount: val[:amount] })
        else
          products[val[:product_id]] = [{ attr_id: val[:attr_val_id], amount: val[:amount] }]
        end
      end
      total_amount = 0.0
      products_cart = products.map do |product_id, attr_value|
        product = Product.find_by(id: product_id)
        images = product.images.map { |img| { image: url_for(img) } }.map(&:values).flatten
        attr_value.map do |attr_val|
          av = AttributeValue.find_by(id: attr_val[:attr_id])
          pa_name = av.product_attributes.pluck(:name)
          pa_value = [av.attribute_1, av.attribute_2].compact
          price = av.price_attribute_product
          discount = av.discount_attribute_product * 100
          quantity = attr_val[:amount].to_i
          amount = ((price * quantity * discount) / 100).to_f.round(2)
          total_amount += amount
          {
            product: product,
            pro_images: images,
            name: pa_name,
            quantity: quantity,
            id: '',
            price: price,
            discount: discount,
            amount: amount,
            stock: av.stock,
            attribute_value: pa_value,
            attr_id: av.id
          }
        end
      end.flatten
      render json: success_message(
        I18n.t('messages.success.cart.list_carts'),
        products_cart: products_cart,
        total_amount: total_amount.round(2),
        is_current: false
      )
    end
  end

  def update
    cart = current_user.carts.is_pending.first
    return render json: error_message(I18n.t('messages.warning.cart.empty_cart')) unless cart

    cart_item_ids = cart.cart_items.pluck(:id)
    params = request.params
    if cart_item_ids.include?(params[:cart_item_id].to_i)
      CartItem.find_by(id: params[:cart_item_id]).update(quantity: params[:quantity])
    end
    render json: success_message('Your card updated successfully')
  end

  def delete_cart_item
    item_id = request.params[:cart_item_id].to_i
    cart = current_user.carts.is_pending.first
    cart_item_ids = cart.cart_items.pluck(:id)
    if cart_item_ids.include?(item_id)
      CartItem.find_by(id: item_id).destroy
      cart.destroy if cart.cart_items.blank?
      render json: success_message(I18n.t('messages.success.cart.destroy'))
    else
      render json: error_message(I18n.t('messages.warning.cart.destroy'))
    end
  end

  private

  def product_values(cart)
    total_amount = 0.0
    return render json: error_message(I18n.t('messages.warning.cart.empty_cart')) if cart.cart_items.blank?

    products_cart = cart.cart_items.map do |cart_item|
      product = cart_item.product
      images = product.images.map { |img| { image: url_for(img) } }.map(&:values).flatten
      attr_value = cart_item.attribute_value
      pa_name = attr_value.product_attributes.pluck(:name).compact
      pa_value = [attr_value.attribute_1, attr_value.attribute_2].compact
      quantity = cart_item.quantity
      price = attr_value.price_attribute_product
      discount = attr_value.discount_attribute_product * 100
      amount = ((price * quantity * discount) / 100).to_f.round(2)
      total_amount += amount
      {
        product: product,
        pro_images: images,
        name: pa_name,
        id: cart_item.id,
        quantity: quantity,
        price: price,
        discount: discount,
        amount: amount,
        stock: attr_value.stock,
        attribute_value: pa_value,
        attr_id: attr_value.id
      }
    end
    render json: success_message(
      I18n.t('messages.success.cart.list_carts'),
      products_cart: products_cart,
      total_amount: total_amount.round(2),
      is_current: true
    )
  end
end
