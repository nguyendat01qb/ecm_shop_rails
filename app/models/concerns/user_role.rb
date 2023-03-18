class UserRole
  def initialize(user, options = {})
    @user = user
    @id = options[:user_id] || @user.id
  end

  def admin?
    @user.is_admin
  end
end