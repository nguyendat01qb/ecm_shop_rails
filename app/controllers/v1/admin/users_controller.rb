class V1::Admin::UsersController < V1::BaseAuthController
  before_action :authorize_admin!

  def load_admins
    page = params[:page].to_i
    per_page = 10
    admins = User.all.map { |user| user if user.current_admin }.compact
    admins = Kaminari.paginate_array(admins).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.user.list_admins'),
      admins: ActiveModelSerializers::SerializableResource.new(
        admins,
        each_serializer: User::ListUserSerializer
      ),
      total_page: admins.total_pages,
      per_page: per_page,
      page: page,
      total: admins.total_count
    )
  end

  def load_users
    page = params[:page].to_i
    per_page = 10
    users = User.all.select(:id, :name, :phone, :email, :sign_in_count, :created_at).page(page).per(per_page)
    users_new = users.map do |user|
      avatar_url = url_for(user.avatar).presence
      {
        user: ActiveModelSerializers::SerializableResource.new(
          user,
          each_serializer: User::ListUserSerializer
        ),
        avatar_url: avatar_url
      }
    end
    render json: success_message(
      I18n.t('messages.success.user.list_users'),
      users: users_new,
      total_page: users.total_pages,
      per_page: per_page,
      page: page,
      total: users.total_count
    )
  end
end
