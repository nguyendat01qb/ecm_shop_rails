class V1::Admin::ProductsController < V1::BaseController
  before_action :authorize_admin!

  def load_products
    page = params[:page].to_i
    per_page = 10
    products = Product.all.select(:id, :title, :price, :discount, :quantity, :price_cents, :product_type, :brand_id, :created_at).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.product.list_products'),
      products: ActiveModelSerializers::SerializableResource.new(
        products,
        each_serializer: Product::ListProductSerializer
      ),
      total_page: products.total_pages,
      per_page: per_page,
      page: page,
      total: products.total_count
    )
  rescue => e
    Slack::PushErrorService.new({ error: e, detail: e.backtrace[0..5].join('\n') }, 'Error product').push
  end
end