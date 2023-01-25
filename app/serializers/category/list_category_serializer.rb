class Category::ListCategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :meta_title, :parent_category, :slug, :created_at

  def parent_category
    return unless object.parent_category
    object.parent_category.title
  end

  def created_at
    object.created_at.strftime("%H:%M %d/%m/%Y")
  end
end