class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :authorize_admin!

  def index; end

  def admin; end

  def show; end

  def new
    @user = User.new
  end

  def create
    create, @user, message = Admin::Users::CreateService.call(user_params)

    if create
      flash[:success] = message
      redirect_to admin_users_url
    else
      flash[:danger] = message
      render :new
    end
  end

  def edit; end

  def update
    update, message = Admin::Users::UpdateService.call(@user, user_params)

    status = update ? :success : :danger
    flash[status] = message
    render :edit
  end

  def destroy
    destroy, message = Admin::Users::DestroyService.call(@user)

    status = destroy ? :success : :danger
    flash[status] = message
    redirect_to admin_users_url
  end

  def export_csv
    csv = Admin::Users::ExportCsvService.new(User.all, User::CSV_ATTRIBUTES)
    respond_to do |format|
      format.csv { send_data csv.perform, filename: "users-#{Date.current}.csv"}
    end
  end

  def export_admin_csv
    csv = Admin::Users::ExportCsvService.new(User.has_role_admin, User::CSV_ATTRIBUTES)
    respond_to do |format|
      format.csv { send_data csv.perform, filename: "admins-#{Date.current}.csv"}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :phone,
      :gender,
      :email,
      :password,
      :password_confirmation,
      :avatar,
      :roles
    )
  end
end
