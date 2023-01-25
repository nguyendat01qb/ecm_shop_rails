class V1::Admin::CategoriesController < V1::BaseController
  before_action :set_category, only: %i[show edit update destroy]
  # before_action :authorize_admin!

  def load_categories
    page = params[:page].to_i
    per_page = 10
    categories = Category.all.select(:id, :title, :meta_title, :slug, :created_at, :category_id).page(page).per(per_page)
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
  rescue => e
    Slack::PushErrorService.new({ error: e, detail: e.backtrace[0..5].join('\n') }, 'Error category').push
  end

  def create
    # create, @category, message = Admin::Categories::CreateService.call(category_params)

    # if create
    #   flash[:success] = message
    #   redirect_to admin_categories_path
    # else
    #   flash[:danger] = message
    #   render :new
    # end
  rescue => e
    Slack::PushErrorService.new({ error: e }, 'Error category').push
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
  end

  def category_params
    params.require(:category).permit(
      :title,
      :meta_title,
      :content,
      :category_id
    )
  end
end
