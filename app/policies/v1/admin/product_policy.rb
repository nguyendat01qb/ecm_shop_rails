class V1::Admin::ProductPolicy < BasePolicy
  def load_products?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end