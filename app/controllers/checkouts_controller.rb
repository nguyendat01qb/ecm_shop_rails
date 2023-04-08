class CheckoutsController < ApplicationController
  include Stud
  before_action :authenticate_user

  def show; end

  def success; end

  def error; end

  def voucher
    result, message, cost = Client::Checkout::Voucher.call(current_user, params[:voucher])
    render json: { status: 200, result: result, message: message, cost: cost }
  end

  def payment
    case params[:payment_gateway]
    when 'STRIPE'
      html = render_to_string partial: 'checkouts/shared/stripe', layout: false
      data = { method: 'STRIPE', html: html }
    when 'MOMO'
      create, order = Client::Order::CreateService.execute!(
        current_user,
        Order.statuses[:paying_excute],
        Order.payment_gateways[:momo],
        params[:shipping],
        params[:voucher],
        Order.new_token
      )

      if create
        url = Client::Checkout::MomoService.call(current_user, order)
        data = { method: 'MOMO', url: url }
        status = 200
        message = 'successfully'
      else
        status = 500
        essage = 'Invalid when payment'
      end
    when 'COD'
      create, @order = Client::Order::CreateService.execute!(
        current_user,
        Order.statuses[:pending],
        Order.payment_gateways[:cod],
        params[:shipping],
        params[:voucher],
        Order.new_token
      )

      if create
        html = render_to_string partial: 'checkouts/success', layout: false
        data = { method: 'COD', html: html }
        status = 200
        message = 'successfully'
      else
        status = 500
        message = 'Invalid when payment'
      end
    else
      status = 400
      message = 'Invalid when payment'
    end

    render json: { status: status, message: message, data: data }
  end

  def stripe_payment; end

  def payment_with_stripe
    intent, address = Client::Stripe::PaymentIntent.call(current_user, params[:shipping], params[:voucher])

    data = {
      key_secret: intent,
      address: address,
      user: current_user,

      url: {
        success: success_checkout_url,
        error: error_checkout_url
      }
    }
    render json: { status: 200, message: 'successfully', data: data }
  end

  def check_order_stripe
    @order = Order.find_by(token: params[:payment_intent_id])
    status = @order.nil? ? 500 : 200

    html = render_to_string partial: 'checkouts/success', layout: false
    render json: { status: status, html: html }
  end
end
