class V1::Admin::BrandsController < V1::Admin::BaseAuthController
  def load_brands
    page = params[:page].to_i
    per_page = 10
    brands = Brand.all.select(:id, :title, :created_at, :updated_at).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.brand.list_brands'),
      brands: ActiveModelSerializers::SerializableResource.new(
        brands,
        each_serializer: Brand::AdminBrandSerializer
      ),
      total_page: brands.total_pages,
      per_page: per_page,
      page: page,
      total: brands.total_count
    )
  end

  def search
    per_page = params[:per_page]
    page = 1
    brands = Kaminari.paginate_array(Brand.query_search(:title,
                                                        params[:brand_name]).order(created_at: :desc)).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.brand.list_brands'),
      brands: ActiveModelSerializers::SerializableResource.new(
        brands,
        each_serializer: Brand::AdminBrandSerializer
      ),
      total_page: brands.total_pages,
      per_page: per_page,
      page: page,
      total: brands.total_count
    )
  end
end
