class V1::BaseController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  protect_from_forgery with: :null_session

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

  def authorize_admin!
    authorize current_user
  end
end
