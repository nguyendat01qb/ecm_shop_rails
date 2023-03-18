class Admin::UserPolicy < BasePolicy
  def index?
    can_manager?
  end

  def admin?
    can_manager?
  end

  def show?
    can_manager?
  end

  def new?
    can_manager?
  end

  def create?
    can_manager?
  end

  def edit?
    can_manager?
  end

  def update?
    can_manager?
  end

  def destroy?
    can_manager?
  end

  def export_csv?
    can_manager?
  end

  def export_admin_csv?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end
