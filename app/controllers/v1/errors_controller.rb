class V1::ErrorsController < V1::BaseController
  def catch_404
    render json: error_message(I18n.t('messages.errors.router_invalid'))
  end
end
