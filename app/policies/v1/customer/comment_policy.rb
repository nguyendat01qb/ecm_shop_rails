class V1::Customer::CommentPolicy < BasePolicy
  def create?
    can_customer?
  end


  def destroy?
    can_customer?
  end

  private

  def can_customer?
    return false unless user

    (user.has_role? :admin) || (user.has_role? :customer)
  end
end