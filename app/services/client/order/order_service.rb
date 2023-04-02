class Client::Order::OrderService < ApplicationService
  def initialize(current_user, cart, order_params)
    @current_user = current_user
    @cart = cart
    @order_params = order_params
  end

  def execute!
    address = current_user.addresses.current_address
    return [false, I18n.t('messages.error.address.not_found')] if address.nil?

    cart_items = cart.cart_items
    return [false, I18n.t('messages.error.cart.blank')] if cart_items.blank?

    payment_gateway = order_params[:payment_gateway]
    token = order_params[:token]
    # total_amount = order_params[:total_amount]
    transport_fee = order_params[:transport_fee]
    voucher_id = order_params[:voucher_id]
    total_bill = order_params[:total_bill]

    product_ids = cart_items.group_by(&:product_id).keys.uniq
    products = Product.where(id: product_ids)

    voucher = Voucher.find_by(id: voucher_id) if voucher_id.present?
    attribute_value_ids = cart_items.group_by(&:attribute_value_id).keys.uniq
    attribute_values = AttributeValue.where(id: attribute_value_ids)

    order = Order.new(
      status: Order::STATUSES[:pending],
      address_id: address.id,
      payment_gateway: payment_gateway,
      user_id: current_user.id,
      total: total_bill,
      token: token,
      discount: voucher.nil? ? 0 : voucher.cost.to_f,
      shipping: transport_fee
    )

    ActiveRecord::Base.transaction do
      if voucher.present?
        begin
          voucher.update(apply_amount: voucher.apply_amount + 1)
          user_voucher = current_user.user_vouchers.by_voucher_id_and_status(voucher_id,
                                                                             UserVoucher::STATUSES[:applying])
          user_voucher.update!(status: UserVoucher::STATUSES[:applied])
        rescue ActiveRecord::StatementInvalid => e
          return false
        end
      end

      create = order.save

      cart_items.each do |cart_item|
        order_item = order.order_items.build(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          stock_keeping_unit: cart_item.stock_keeping_unit
        )

        if cart_item.attribute_value_id.present?
          attribute_value = attribute_values.find_by(id: cart_item.attribute_value_id)
          if attribute_value.stock < cart_item.quantity
            raise ActiveRecord::Rollback
            [false, 'Out of stock', order]
          else
            order_item.attribute_value_id = cart_item.attribute_value_id
          end
        else
          product = products.find_by(id: cart_item.product_id)

          if product.quantity < cart_item.quantity
            raise ActiveRecord::Rollback
            [false, 'Out of stock', order]
          else
            order_item.price = product.price.to_f
            order_item.discount = product.discount
          end
        end
        order_item.save
      end

      if create
        order.order_items.each do |order_item|
          quantity_order = order_item.quantity.to_i
          if order_item.attribute_value_id.nil?
            product = Product.find_by(id: order_item.product_id)
            quantity = product.quantity.to_i - quantity_order
            product.update(quantity: quantity)
          else
            attribute_value = AttributeValue.find_by(id: order_item.attribute_value_id)
            quantity = attribute_value.stock.to_i - quantity_order
            attribute_value.update(stock: quantity)
            product_id = attribute_value.product_attributes.pluck(:product_id).uniq
            product = Product.find_by(id: product_id)
            product.update(quantity: quantity_order)
          end
        end
        cart.destroy
      end

      [create, I18n.t('messages.success.order.created'), order]
    end
  end

  private

  attr_accessor :current_user, :cart, :order_params
end
