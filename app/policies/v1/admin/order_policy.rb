class V1::Admin::OrderPolicy < BasePolicy
  def load_orders?
    can_manager?
  end

  def submit?
    can_manager?
  end

  def cancel?
    can_manager?
  end

  def approve?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end
