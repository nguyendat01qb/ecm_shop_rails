class V1::Customer::CommentsController < V1::BaseController
  before_action :authenticate_user!

  def create
    content = request.params.delete(:comment)
    product_id = request.params.delete(:product_id)
    request.params.delete(:format)
    request.params.delete(:controller)
    request.params.delete(:action)

    comment = current_user.comments.new(content: content, product_id: product_id, images: request.params.values)

    if comment.save
      render json: success_message(I18n.t('messages.success.comment.created'))
    elsif comment.errors.messages.keys.map(&:to_s).include?('content')
      render json: error_message(I18n.t('messages.error.comment.content_to_short'))
    else
      render json: error_message(I18n.t('messages.error.comment.create'))
    end
  end
end
