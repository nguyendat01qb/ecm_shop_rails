class V1::Admin::DashboardPolicy < BasePolicy
  def numbers?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end