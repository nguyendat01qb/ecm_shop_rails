class Admin::OrdersController < Admin::BaseAdminController
  before_action :set_order, only: %i[show edit update destroy]
  # before_action :set_status, only: %i[submit cancel success]

  def index; end

  def edit; end

  def show; end

  def destroy
    destroy = @order&.destroy

    message = destroy ? 'Brand was successfully destroy.' : 'Brand was failure destroy.'
    status = destroy ? :success : :danger

    flash[status] = message
    redirect_to admin_orders_path
  end

  def submit
    @order.update(status: Order.statuses[:delivering])
    render json: { status: 200, message: 'successfully' }
  end

  def cancel
    @order.update(status: Order.statuses[:canceled])
    render json: { status: 200, message: 'successfully' }
  end

  def success
    @order.update(status: Order.statuses[:success])
    render json: { status: 200, message: 'successfully' }
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
