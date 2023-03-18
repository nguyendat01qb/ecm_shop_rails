class Admin::ProductPolicy < BasePolicy
  def index?
    can_manager?
  end

  def show?
    can_manager?
  end

  def show_attribute?
    can_manager?
  end

  def show_no_attribute?
    can_manager?
  end

  def show_attribute2?
    can_manager?
  end

  def new?
    can_manager?
  end

  def edit?
    can_manager?
  end

  def update?
    can_manager?
  end

  def destory?
    can_manager?
  end

  def export_csv?
    can_manager?
  end

  private

  def can_manager?
    user.has_role? :admin
  end
end