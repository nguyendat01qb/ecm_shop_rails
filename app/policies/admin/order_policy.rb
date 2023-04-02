class Admin::OrderPolicy < BasePolicy
  def index?
    can_manager?
  end

  def show?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end