class V1::Customer::HomeController < V1::BaseController
  def categories
    categories = Category.is_parent.select(:id, :title)
    childs = Category.is_child.select(:id, :title, :category_id).group_by(&:category_id)
    childs.delete(nil)
    render json: success_message(
      I18n.t('messages.success.category.list_categories'),
      categories: categories,
      childs: childs
    )
  end

  def brands
    brands = Brand.all.select(:id, :title)
    render json: success_message(
      I18n.t('messages.success.brand.list_brands'),
      brands: ActiveModelSerializers::SerializableResource.new(
        brands,
        each_serializer: Brand::ListBrandSerializer
      )
    )
  end

  def load_default_products
    per_page = request.params[:per_page] ? request.params[:per_page].to_i : 6
    products = Product.all.select(:id, :title, :price, :price_cents, :discount, :quantity).page(1).per(per_page)
    images = products.each_with_object({}) do |product, result|
      result[product.id] = url_for(product.images.first)
    end
    is_load_more = products.total_pages > 1
    render json: success_message(
      I18n.t('messages.success.product.list_products'),
      products: ActiveModelSerializers::SerializableResource.new(
        products,
        each_serializer: Product::FilterProductsSerializer
      ),
      images: images,
      is_load_more: is_load_more,
      per_page: per_page
    )
  end

  def filter_products
    category_id = request.params[:category_id].to_i
    brand_id = request.params[:brand_id].to_i
    per_page = request.params[:per_page] ? request.params[:per_page].to_i : 6
    products =
      if !brand_id.zero? && !category_id.zero?
        Kaminari.paginate_array(load_by_category(category_id, per_page).map do |product|
          product if product.brand_id == brand_id
        end).page(1).per(per_page)
      elsif !category_id.zero?
        load_by_category(category_id, per_page)
      elsif !brand_id.zero?
        Product.where(brand_id: brand_id).select(:id, :title, :price, :price_cents, :discount,
                                                 :quantity).page(1).per(per_page)
      else
        Product.all.select(:id, :title, :price, :price_cents, :discount, :quantity).page(1).per(per_page)
      end
    if products.present?
      images = products.each_with_object({}) do |product, result|
        result[product.id] = url_for(product.images.first)
      end
      is_load_more = products.total_pages > 1

      render json: success_message(
        I18n.t('messages.success.product.list_products'),
        products: ActiveModelSerializers::SerializableResource.new(
          products,
          each_serializer: Product::FilterProductsSerializer
        ),
        images: images,
        is_load_more: is_load_more,
        per_page: per_page
      )
    else
      render json: error_message(I18n.t('messages.error.product.empty'))
    end
  end

  def get_product_cart
    if current_user.blank? || !user_signed_in?
      return render json: unauthorized_message(I18n.t('messages.error.missing_api_token'))
    end

    cart = current_user.carts.is_pending.first
    if cart.blank? || cart.cart_items.blank?
      return render json: error_message(I18n.t('messages.warning.cart.empty_cart'))
    end

    product_id = cart.cart_items.pluck(:product_id).uniq
    number_of_items = product_id.length
    render json: success_message('OK', number_of_items: number_of_items)
  end

  private

  def load_by_category(category_id, per_page)
    category = Category.friendly.find_by(id: category_id)
    childs = category.childs

    products = []
    if childs.present?
      childs.each do |item|
        products.concat(item.products.select(:id, :title, :price, :price_cents, :discount, :quantity, :brand_id))
      end
    else
      products = category.products.select(:id, :title, :price, :price_cents, :discount, :quantity, :brand_id)
    end
    Kaminari.paginate_array(products).page(1).per(per_page)
  end
end
