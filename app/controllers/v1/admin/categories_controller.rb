class V1::Admin::CategoriesController < V1::Admin::BaseAuthController
  def load_categories
    page = params[:page].to_i
    per_page = 10
    categories = Category.all.select(:id, :title, :meta_title, :slug, :created_at,
                                     :category_id).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.category.list_categories'),
      categories: ActiveModelSerializers::SerializableResource.new(
        categories,
        each_serializer: Category::ListCategorySerializer
      ),
      total_page: categories.total_pages,
      per_page: per_page,
      page: page,
      total: categories.total_count
    )
  rescue StandardError => e
    Slack::PushErrorService.new({ error: e, detail: e.backtrace[0..5].join('\n') }, 'Error category').push
  end

  def search
    per_page = params[:per_page]
    page = params[:page]
    categories = Kaminari.paginate_array(Category.query_search(:title,
                                                               params[:category_name]).select(:id, :title, :meta_title, :slug, :created_at,
                                                                                              :category_id).order(created_at: :desc)).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.category.list_categories'),
      categories: ActiveModelSerializers::SerializableResource.new(
        categories,
        each_serializer: Category::ListCategorySerializer
      ),
      total_page: categories.total_pages,
      per_page: per_page,
      page: page,
      total: categories.total_count
    )
  end
end
