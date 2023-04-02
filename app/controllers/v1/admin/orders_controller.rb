class V1::Admin::OrdersController < V1::Admin::BaseAuthController
  def load_orders
    page = params[:page].to_i
    per_page = 10
    orders = Order.all.select(:id, :token, :status, :payment_gateway, :total, :created_at).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.order.list_orders'),
      orders: ActiveModelSerializers::SerializableResource.new(
        orders,
        each_serializer: Order::ListOrderSerializer
      ),
      total_page: orders.total_pages,
      per_page: per_page,
      page: page,
      total: orders.total_count
    )
  rescue StandardError => e
    Slack::PushErrorService.new({ error: e, detail: e.backtrace[0..5].join('\n') }, 'Error order').push
  end

  def submit
    order = Order.find(params[:order_id])
    od_status = order.status
    od_params = {}
    od_params[:status] = case od_status
                         when Order::STATUSES[:pending]
                           Order::STATUSES[:approved]
                         when Order::STATUSES[:approved]
                           Order::STATUSES[:shipping]
                         when Order::STATUSES[:shipping]
                           Order::STATUSES[:delivering]
                         else
                           Order::STATUSES[:canceled]
                         end
    return render json: success_message(I18n.t('messages.success.order.update'), order) if order.update!(od_params)

    render json: error_message(I18n.t('messages.error.order.update'))
  end

  def cancel
    order = Order.find(params[:order_id])
    if order.update!(status: Order::STATUSES[:canceled])
      return render json: success_message(I18n.t('messages.success.order.update'), order)
    end

    render json: error_message(I18n.t('messages.error.order.update'))
  end

  def approve
    order = Order.find(params[:order_id])
    if order.update!(status: Order::STATUSES[:success])
      return render json: success_message(I18n.t('messages.success.order.update'), order)
    end

    render json: error_message(I18n.t('messages.error.order.update'))
  end
end
