class Admin::Products::CreateService < ApplicationService
  def initialize(product_params)
    @product_params = product_params
  end

  def call
    ActiveRecord::Base.transaction do
      product = Product.new(product_params.except(:product_attribute_1, :product_attribute_2))
      product_attribute_1 = product_params[:product_attribute_1]
      product_attribute_2 = product_params[:product_attribute_2]
      if product_attribute_1.nil? && product_attribute_2.nil? && (product_params[:price].to_f.zero? || product_params[:discount].to_f.zero? || product_params[:images].blank? || product_params[:quantity].blank?)
        return [false, 'Price | Discount | Image | Quantity is not blank',
                product]
      end
      product.save!

      return [true, 'Product created successfully', product] if product_attribute_1.nil? && product_attribute_2.nil?

      [product_attribute_1, product_attribute_2].compact.each do |processing_product_attribute|
        name = processing_product_attribute[:name]
        product_attribute = product.product_attributes.new(name: name, images: product_attribute_1[:images])

        product_attribute.save!
      end

      product_attribute_values_1 = product_attribute_1&.dig(:attribute_value)
      product_attribute_values_2 = product_attribute_2&.dig(:attribute_value)

      list_attribute_title_1 = product_attribute_values_1&.dig(:attribute)
      list_attribute_title_2 = product_attribute_values_2&.dig(:attribute)

      if product_attribute_values_2.nil?
        if list_attribute_title_1.length < list_attribute_title_1.uniq.length
          return [false, "Can't create this product",
                  product]
        end
        product_params = {
          price: product_attribute_values_1[:price_attribute_product][0],
          discount: product_attribute_values_1[:discount_attribute_product][0]
        }

        quantity = 0
        list_attribute_title_1.each_with_index do |attribute_1_title, index|
          quantity += product_attribute_values_1[:stock][index].to_i
          created_attribute_value = AttributeValue.create!(
            attribute_1: attribute_1_title,
            price_attribute_product: product_attribute_values_1[:price_attribute_product][index],
            discount_attribute_product: product_attribute_values_1[:discount_attribute_product][index],
            stock: product_attribute_values_1[:stock][index]
          )
          product.product_attributes[0].product_attribute_values.create!(attribute_value_id: created_attribute_value.id)
        end
        product_params[:quantity] = quantity unless quantity.zero?
        product.update!(product_params)
        return [true, 'Product created successfully', product]
      else
        if list_attribute_title_2.length < list_attribute_title_2.uniq.length
          return [false, "Can't create this product",
                  product]
        end

        product_params = {
          price: product_attribute_values_1[:price_attribute_product][0],
          discount: product_attribute_values_1[:discount_attribute_product][0]
        }
        count = 0
        quantity = 0
        list_attribute_title_1.each do |attribute_1_title|
          list_attribute_title_2.each do |attribute_2_title|
            quantity += product_attribute_values_1[:stock][count].to_i
            created_attribute_value = AttributeValue.create!(
              attribute_1: attribute_1_title, attribute_2: attribute_2_title,
              price_attribute_product: product_attribute_values_1[:price_attribute_product][count],
              discount_attribute_product: product_attribute_values_1[:discount_attribute_product][index],
              stock: product_attribute_values_1[:stock][count]
            )

            product.product_attributes[0].product_attribute_values.create!(attribute_value_id: created_attribute_value.id)
            product.product_attributes[1].product_attribute_values.create!(attribute_value_id: created_attribute_value.id)
            count += 1
          end
        end
        product_params[:quantity] = quantity unless quantity.zero?
        product.update!(product_params)
        return [true, 'Product created successfully', product]
      end
    rescue StandardError => e
      Slack::PushErrorService.new({ error: e, detail: e.backtrace[0..5].join('\n') }, 'Error create product').push
    end
  end

  private

  attr_accessor :product_params
end
