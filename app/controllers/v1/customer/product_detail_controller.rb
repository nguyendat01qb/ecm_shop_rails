class V1::Customer::ProductDetailController < V1::BaseController
  def select_attribute
    product_attribute = ProductAttribute.includes(:attribute_values).find_by(id: params[:data][:id_attr1])
    attribute_values = product_attribute.attribute_values

    product_attr =
      if params[:data][:id_attr2].nil?
        attribute_values.find_by(attribute_1: params[:data][:value_attr1])
      else
        attribute_values.where(attribute_1: params[:data][:value_attr1]).find_by(attribute_2: params[:data][:value_attr2])
      end

    render json: success_message(
      I18n.t('messages.success.product.list_products'),
      product_attr: ActiveModelSerializers::SerializableResource.new(
        product_attr,
        each_serializer: Product::ProductDetailSerializer
      )
    )
  end
end
