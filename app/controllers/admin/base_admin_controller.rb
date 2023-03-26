class Admin::BaseAdminController < BaseAuthController
  layout 'admin'

  before_action :verify_authority
  protect_from_forgery with: :exception
  before_action :authenticate_admin!

  private

  def user_not_authorized
    flash[:danger] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
  end

  def admin?
    current_user.has_role? :admin
  end

  def authenticate_admin!
    return redirect_to root_path unless current_user

    cookies[:api_token] = current_user.api_token_digest
    return if admin?

    redirect_to root_path
  end
end
