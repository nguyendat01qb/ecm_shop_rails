class V1::Admin::VoucherPolicy < BasePolicy
  def load_vouchers?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end
