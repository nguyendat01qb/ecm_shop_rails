class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[ show edit update destroy edit_product]
  before_action :authorize_admin!, only: [:index, :show, :edit, :update, :show, :destory]

  def index; end

  def show;end

  def show_attribute
    html = render_to_string partial: "admin/products/shared/add_attribute", :layout => false
    render json: {status: 200, message:"successfully", html: html}
  end

  def show_no_attribute
    html = render_to_string partial: "admin/products/shared/attribute_form", :layout => false
    render json: { status: 200, message:"successfully", html: html }
  end

  def show_attribute2
    html = render_to_string partial: "admin/products/shared/attribute2", :layout => false
    render json: {status: 200, message:"successfully", html: html}
  end

  def new
    @product = Product.new
  end

  def create
    create, message, @product = Admin::Products::CreateService.call(product_params)

    if create
      flash[:success] = message
      redirect_to admin_products_path
    else
      flash[:danger] = message
      render :new
    end
  end

  def edit;end

  def edit_product
    attr1 = render_to_string partial: "admin/products/shared/add_attribute", :layout => false
    attr2 = render_to_string partial: "admin/products/shared/attribute2", :layout => false

    data = {
      attributes: @product.product_attributes,
      value: @product.product_attributes[0].attribute_values,
      images: @product.product_attributes[0].images.map{ |image| url_for(image) },
    }

    render json: { status: 200, message: "successfully", data: data, html: { attr1: attr1, attr2: attr2 }}
  end


  def update
    update = Admin::Products::UpdateService.call(@product, product_params)

    if update
      flash[:success] = "Product was successfully updated."
    else
      flash[:danger] = "Product was failure updated."
    end

    redirect_to admin_products_path
  end

  def destroy
    destroy, message = Admin::Products::DestroyService.call(@product)

    status = destroy ? :success : :danger
    flash[status] = message
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.friendly.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :title,
      :meta_title,
      :categories,
      :content,
      :quantity,
      :brand_id,
      :price,
      :discount,
      images: [],
      category_ids: [],
      product_attribute_1: [
        :name,
        attribute_value: [
          attribute: [],
          price_attribute_product: [],
          discount_attribute_product: [],
          stock: [],
        ],
        images: []
      ],
      product_attribute_2: [
        :name,
        attribute_value: [
          attribute: [],
        ]
      ],
      update: [
        :insert ,
        destroy: [
          attribute_value: []
        ]
      ]
    )
  end
end
