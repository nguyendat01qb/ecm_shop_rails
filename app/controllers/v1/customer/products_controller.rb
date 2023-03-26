class V1::Customer::ProductsController < V1::BaseController
  before_action :verify_authority, only: [:add_to_cart]

  def images
    product_id = request.params[:id]
    image_urls = Product.find_by(id: product_id).images.map do |image|
      url_for(image)
    end
    render json: success_message(
      I18n.t('messages.success.product.images'),
      image_urls: image_urls
    )
  end

  def show
    product_id = request.params[:id]
    product = Product.find_by(id: product_id)
    product_attributes = product.product_attributes.select(:id, :name)
    index = 0
    attr_values = product_attributes.each_with_object({}) do |pa, result|
      if index.zero?
        (result[[pa.id, pa.name]] ||= []).push(pa.attribute_values.pluck(:attribute_1).uniq)
      elsif index == 1
        (result[[pa.id, pa.name]] ||= []).push(pa.attribute_values.pluck(:attribute_2).uniq)
      end
      index += 1
    end
    render json: success_message(
      I18n.t('messages.success.product.product_detail'),
      product: ActiveModelSerializers::SerializableResource.new(
        product,
        each_serializer: Product::ProductDetailSerializer
      ),
      attr_values: attr_values
    )
  end

  def search
    @products = Product.query_search(:title, params[:search]).order(created_at: :desc)

    html = render_to_string partial: 'home/shared/features_items', layout: false
    render json: { status: 200, message: 'Successfully', html: html }
  end

  def select_attribute
    product_attribute = ProductAttribute.includes(:attribute_values).find_by(id: params[:id_attr1])
    attribute_values = product_attribute.attribute_values

    attribute_value =
      if params[:id_attr2].nil?
        attribute_values.find_by(attribute_1: params[:value_attr1], attribute_2: nil)
      else
        attribute_values.where(attribute_1: params[:value_attr1]).find_by(attribute_2: params[:value_attr2])
      end

    render json: success_message(
      I18n.t('messages.success.product.attributes'),
      attribute_value: ActiveModelSerializers::SerializableResource.new(
        attribute_value,
        each_serializer: Product::ProductAttrSerializer
      )
    )
  end

  def add_to_cart
    return render json: error_message(I18n.t('messages.warning.cart.empty_cart')) unless current_user

    cart = current_user.carts.is_pending.first
    cart ||= current.carts.create!(status: Cart::STATUSES[:pending])
    params = request.params
    product_id = request.params[:product_id].to_i
    attr_value_id = AttributeValue.find_by(attribute_1: params[:value_attr1], attribute_2: params[:value_attr2]).id
    if cart.cart_items.pluck(:product_id, :attribute_value_id).include?([product_id, attr_value_id])
      cart_item = cart.cart_items.find_by(product_id: product_id, attribute_value_id: attr_value_id)
      quantity = cart_item.quantity + params[:quantity].to_i
      cart_item.update!(quantity: quantity)
    else
      cart_item = cart.cart_items.create!(product_id: product_id, attribute_value_id: attr_value_id,
                                          quantity: params[:quantity])
    end
    render json: success_message(
      I18n.t('messages.success.product.add_cart'),
      cart_item: cart_item
    )
  end

  def comments
    product = Product.find(params[:id])
    comments = product.comments.group_by(&:comment_id)
    pr_comments = comments[nil].index_by(&:id)
    pr_comment_keys = pr_comments.keys
    user_ids = comments.values.flatten.pluck(:user_id).uniq
    users =  User.where(id: user_ids).select(:id, :name).index_by(&:id)
    cmt_keys = comments.keys.compact
    comments = pr_comment_keys.each_with_object([]) do |p_id, result|
      pr_cmt = pr_comments[p_id]
      if cmt_keys.include?(p_id)
        childs = comments[p_id]
        childs = childs.each_with_object([]) do |child, child_result|
          user = users[child.user_id]
          child_result << {
            id: child.id,
            user: {
              name: user.name,
              avatar: url_for(user.avatar)
            },
            content: child.content,
            created_at: child.created_at.strftime('%H:%M %d/%m/%Y')
          }
        end
        user = users[pr_cmt.user_id]
        result << {
          id: pr_cmt.id,
          user: {
            name: user.name,
            avatar: url_for(user.avatar)
          },
          content: pr_cmt.content,
          created_at: pr_cmt.created_at.strftime('%H:%M %d/%m/%Y'),
          childs: childs
        }
      else
        user = users[pr_cmt.user_id]
        result << {
          id: pr_cmt.id,
          user: {
            name: user.name,
            avatar: url_for(user.avatar)
          },
          content: pr_cmt.content,
          created_at: pr_cmt.created_at.strftime('%H:%M %d/%m/%Y'),
          childs: []
        }
      end
    end
    render json: success_message('OK', comments: comments)
  end
end
