class BaseAuthController < ApplicationController
  before_action :auth_user
  before_action :authenticate_user!
  before_action :is_user
  # before_action :set_api_token

  def auth_user
    (redirect_to(new_user_session_path) && return) unless user_signed_in?

    auth_token = cookies[:auth_token]
    (auth_token.blank? || !available_admin?) && ENV['RAILS_ENV'] != 'test'
    # actions = %w[
    #   import import_time_shift import_csv import_staff_shift
    #   import_csv_template_shift import_csv_master_holiday
    # ]
    # check_auth_token if actions.exclude?(params[:action])
  end

  def is_user
    redirect_to root_path unless current_user.is_admin?
  end

  # rescue_from CanCan::AccessDenied do
  #   flash[:cancan] = I18n.t('messages.errors.permission_errors')
  #   redirect_to manager_root_url
  # end

  private

  def available_admin?
    user_role && current_user.admin?
  end

  def user_role
    @user_role ||= UserRole.new(current_user) if current_user.present?
  end

  def set_api_token
    cookies[:api_token] = {
      value: (current_user.api_token || ''), httponly: true, secure: true, domain: Settings.domain
    }
  end
end
