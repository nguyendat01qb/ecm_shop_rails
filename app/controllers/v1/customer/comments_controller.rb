class V1::Customer::CommentsController < V1::BaseController
  before_action :verify_authority

  def create
    content = request.params.delete(:comment)
    comment_id = request.params.delete(:comment_id)
    product_id = request.params.delete(:product_id)
    request.params.delete(:format)
    request.params.delete(:controller)
    request.params.delete(:action)

    comment_params = {
      content: content,
      product_id: product_id,
      images: request.params.values
    }

    comment_params[:comment_id] = comment_id if comment_id.present?

    comment = current_user.comments.new(comment_params)

    if comment.save
      render json: success_message(I18n.t('messages.success.comment.created'))
    elsif comment.errors.messages.keys.map(&:to_s).include?('content')
      render json: error_message(I18n.t('messages.error.comment.content_to_short'))
    else
      render json: error_message(I18n.t('messages.error.comment.create'))
    end
  end

  def destroy
    comment_id = params[:id]
    comment = Comment.find_by(id: comment_id)
    return render json: error_message(I18n.t('messages.error.comment.delete')) if comment.user_id != current_user.id

    comment.child_comments.delete_all if comment.present? && comment.child_comments
    comment.delete
    render json: success_message(I18n.t('messages.success.comment.deleted'))
  end
end
