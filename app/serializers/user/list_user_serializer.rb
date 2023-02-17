class User::ListUserSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :email, :is_admin, :sign_in_count, :created_at

  def is_admin
    object.has_role? :admin
  end

  def created_at
    object.created_at.strftime("%H:%M %d/%m/%Y")
  end
end
