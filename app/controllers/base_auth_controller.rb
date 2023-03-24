class BaseAuthController < ApplicationController
  before_action :auth_user

  def auth_user
    (redirect_to(new_user_session_path) && return) unless user_signed_in?

    auth_token = cookies[:auth_token]
    (auth_token.blank? || !available_admin?) && ENV['RAILS_ENV'] != 'test'
  end

  # rescue_from CanCan::AccessDenied do
  #   flash[:cancan] = I18n.t('messages.errors.permission_errors')
  #   redirect_to manager_root_url
  # end

  private

  def available_admin?
    user_role && current_user.is_admin?
  end

  def user_role
    @user_role ||= UserRole.new(current_user) if current_user.present?
  end
end
