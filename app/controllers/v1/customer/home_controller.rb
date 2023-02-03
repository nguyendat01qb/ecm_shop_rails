class V1::Customer::HomeController < V1::BaseController
  def filter_products
    @products = Client::Home::FilterProductsService.call(params)

    html = render_to_string partial: 'home/shared/features_items', layout: false
    render json: { status: 200, message: 'Successfully', html: html }
  end
end
