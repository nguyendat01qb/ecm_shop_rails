class V1::Customer::ProductPolicy < BasePolicy
  def add_to_cart?
    can_customer?
  end

  private

  def can_customer?
    return false unless user

    (user.has_role? :admin) || (user.has_role? :customer)
  end
end
