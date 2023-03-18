class Admin::DashboardPolicy < BasePolicy
  def index?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end
