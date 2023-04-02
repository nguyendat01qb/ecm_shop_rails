class Admin::OrdersController < Admin::BaseAdminController
  before_action :set_order, only: %i[show edit update destroy]
  # before_action :set_status, only: %i[submit cancel success]

  def index; end

  def edit; end

  def show; end

  def destroy
    destroy = @order&.destroy

    message = destroy ? 'Order was successfully destroy.' : 'Order was failure destroy.'
    status = destroy ? :success : :danger

    flash[status] = message
    redirect_to admin_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
