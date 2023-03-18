class Admin::DashboardsController < Admin::BaseAdminController
  def index
    @categories = Category.all.each_with_object({}) do |category, result|
      result[category.title] = category.products.count
    end.sort_by { |category| category[1] }.reverse().first(10)
    @products = Product.all.each_with_object({}) do |product, result|
      result[product.title] = product.quantity
    end
    @users = User.all.group_by(&:sign_in_count).each_with_object({}) do |user, result|
      if user[0] > 1
        result["#{user[0]}_times"] = user[1].length
      else
        result["#{user[0]}_time"] = user[1].length
      end
    end
  end
end
