class V1::Admin::DashboardsController < V1::BaseController
  before_action :authorize_admin!

  def numbers
    number_of_users = { name: 'Users', quantity: User.count }
    number_of_categories = { name: 'Categories', quantity: Category.count }
    number_of_products = { name: 'Products', quantity: Product.count }
    number_of_attr_values = { name: 'Attribute Values', quantity: AttributeValue.count }
    number_of_carts = { name: 'Carts', quantity: Cart.count }
    number_of_cart_items = { name: 'Cart Items', quantity: CartItem.count }
    number_of_orders = { name: 'Orders', quantity: Order.count }
    number_of_order_items = { name: 'Order Items', quantity: OrderItem.count }
    render json: success_message(
      I18n.t('messages.success.dashboard.list_numbers'),
      number_of_users: number_of_users,
      number_of_categories: number_of_categories,
      number_of_products: number_of_products,
      number_of_attr_values: number_of_attr_values,
      number_of_carts: number_of_carts,
      number_of_cart_items: number_of_cart_items,
      number_of_orders: number_of_orders,
      number_of_order_items: number_of_order_items
    )
  end

  def linechart; end
end
