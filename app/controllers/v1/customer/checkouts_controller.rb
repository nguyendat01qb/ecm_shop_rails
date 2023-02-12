class V1::Customer::CheckoutsController < V1::BaseController
  def get_order
    return unless current_user

    cart = current_user&.carts&.is_pending&.first
    voucher = current_user.user_vouchers.applying.voucher
    product_values(cart, voucher)
  end

  def voucher
    if current_user.user_vouchers.applying.present?
      return render json: error_message(I18n.t('messages.error.voucher.used_another'))
    end

    voucher = Voucher.find_by(code: request.params[:voucher_code])
    return render json: error_message(I18n.t('messages.error.voucher.empty')) if voucher.blank?
    return render json: error_message(I18n.t('messages.error.voucher.expired')) if voucher.end_time < DateTime.now
    if voucher.discount_mount <= voucher.apply_amount
      return render json: error_message(I18n.t('messages.error.voucher.sold_out'))
    end
    if current_user.user_vouchers.present? && current_user.user_vouchers.by_voucher_id_and_status(voucher.id,
                                                                                                  UserVoucher::STATUSES[:applying])
      return render json: error_message(I18n.t('messages.error.voucher.used_this'))
    end

    cart = current_user&.carts&.is_pending&.first
    current_user.user_vouchers.create!(voucher_id: voucher.id, status: UserVoucher::STATUSES[:applying])
    product_values(cart, voucher)
  end

  def check_cart
    return render json: error_message(I18n.t('messages.error.checkout.required_sign_in')) unless current_user
    if current_user.carts.is_pending.blank? || current_user.carts.is_pending.first.cart_items.blank?
      return render json: error_message(I18n.t('messages.error.checkout.empty_cart'))
    end

    render json: success_message('OK')
  end

  def address
    addresses = current_user.addresses
    current_address = addresses.find_by(id: request.params[:id])
    return render json: error_message(I18n.t('messages.error.address.not_found')) unless current_address

    addresses.update_all(status: false)
    current_address.update!(status: true)
    addresses = current_user.addresses
    address_default = addresses.current_address
    render json: success_message(
      I18n.t('messages.success.address.changed'),
      addresses: addresses,
      address_default: address_default
    )
  end

  private

  def product_values(cart, voucher)
    total_amount = 0.0
    order_item = cart.cart_items.map do |cart_item|
      product = cart_item.product
      images = product.images.map { |img| { image: url_for(img) } }.map(&:values).flatten
      attr_value = cart_item.attribute_value
      pa_name = attr_value.product_attributes.pluck(:name).compact
      pa_value = [attr_value.attribute_1, attr_value.attribute_2].compact
      quantity = cart_item.quantity
      price = attr_value.price_attribute_product
      discount = attr_value.discount_attribute_product * 100
      amount = ((price * quantity * discount).to_f / 100.to_f).round(2)
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
    addresses = current_user.addresses
    address_default = addresses.current_address
    data = {
      order_item: order_item,
      total_amount: total_amount.round(2),
      addresses: addresses,
      address_default: address_default,
      transport_fee: rand(1.0..1.5).round(2),
      is_current: true
    }
    data['voucher'] = voucher if voucher
    render json: success_message(I18n.t('messages.success.cart.list_carts'), data)
  end
end
