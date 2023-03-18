class V1::Admin::UserPolicy < BasePolicy
  def load_users?
    can_manager?
  end

  def load_admins?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end
