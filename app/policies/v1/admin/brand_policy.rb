class V1::Admin::BrandPolicy < BasePolicy
  def load_brands?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end
