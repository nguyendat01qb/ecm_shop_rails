class Category::ListCategorySerializer < ActiveModel::Serializer
  attributes :id, :title, :meta_title, :parent, :slug, :created_at

  def parent
    return unless object.parent
    object.parent.title
  end

  def created_at
    object.created_at.strftime("%H:%M %d/%m/%Y")
  end
end