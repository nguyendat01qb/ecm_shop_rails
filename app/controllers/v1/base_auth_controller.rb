class V1::BaseAuthController < V1::BaseController
  before_action :auth_user

  protected
  def auth_user
    render json: (unauthorized_message(I18n.t('messages.error.please_sign_in'))) && return if current_user.blank?
    render json: (unauthorized_message(I18n.t('messages.error.missing_api_token'))) && return unless api_token?
  end
end
