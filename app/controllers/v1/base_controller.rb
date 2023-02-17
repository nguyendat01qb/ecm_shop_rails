class V1::BaseController < ApplicationController
  include Pundit::Authorization
  include Pagy::Backend
  protect_from_forgery with: :null_session
  before_action :current

  attr_reader :current_user

  protected

  def success_message(message, content = {}, code = 200)
    ResponseTemplate.success(message, content, code)
  end

  def error_message(message, content = {}, code = 500)
    ResponseTemplate.error(message, content, code)
  end

  def unauthorized_message(message, content = {}, code = 401)
    ResponseTemplate.unauthorized(message, content, code)
  end

  def serializers(data, serializer, scope: nil)
    ActiveModelSerializers::SerializableResource.new(data,
                                                     each_serializer: serializer, scope: scope)
  end

  private

  def session_api_token
    cookies_values = request.cookies.to_a.flatten
    index_of_token_key = cookies_values.find_index('api_token');
    request.headers['Api-Token'] || cookies[:api_token] || cookies_values[index_of_token_key.next]
  end

  def token_invalid_json
    render json: unauthorized_message(I18n.t("messages.error.please_sign_in"))
  end

  def current
    if api_token?
      @current_user = current_user ? current_user : User.find_by(api_token_digest: session_api_token)
    else
      @current_user = nil
    end
  end

  def api_token?
    request.headers['Api-Token'].present? || cookies[:api_token].present? || !request.cookies.to_a.flatten.find_index('api_token').nil?
  end

  def authorize_admin!
    token_invalid_json && return unless api_token?
    authorize current_user
  end

  def authenticate_user!
    token_invalid_json && return unless api_token?
    authorize current_user
  end
end
