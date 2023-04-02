class V1::Customer::CheckoutPolicy < BasePolicy
  def create?
    can_customer?
  end


  def get_order?
    can_customer?
  end

  def voucher?
    can_customer?
  end


  def check_cart?
    can_customer?
  end

  private

  def can_customer?
    return false unless user

    (user.has_role? :admin) || (user.has_role? :customer)
  end
end