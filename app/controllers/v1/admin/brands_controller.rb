class V1::Admin::BrandsController < V1::BaseAuthController
  before_action :authorize_admin!

  def load_brands
    page = params[:page].to_i
    per_page = 10
    brands = Brand.all.select(:id, :title, :created_at, :updated_at).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.brand.list_brands'),
      brands: ActiveModelSerializers::SerializableResource.new(
        brands,
        each_serializer: Brand::ListBrandSerializer
      ),
      total_page: brands.total_pages,
      per_page: per_page,
      page: page,
      total: brands.total_count
    )
  end
end
