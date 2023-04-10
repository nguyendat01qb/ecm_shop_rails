class V1::Admin::BaseAuthController < V1::BaseController
  before_action :auth_admin
  before_action :verify_authority

  # rescue_from CanCan::AccessDenied do |_exception|
  #   render json: error_message(I18n.t('messages.errors.permission_errors'))
  # end

  protected

  def auth_admin
    render json: token_invalid_message(I18n.t('messages.errors.please_sign_in')) && return if current_user.blank?
    # render json: error_message(I18n.t('messages.errors.missing_api_token')) && return unless api_token?

    is_admin = current_user.is_admin?
    render json: error_permission(I18n.t('messages.errors.permission_errors')) && return unless is_admin
  end
end
