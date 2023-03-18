class V1::Admin::CategoryPolicy < BasePolicy
  def load_categories?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end