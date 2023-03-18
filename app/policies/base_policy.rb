# frozen_string_literal: true

class BasePolicy
  def initialize(user, params, processing_shop_id)
    @user = user
    @params = params
    @shop_id_param = processing_shop_id
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end

  private

  attr_reader :user, :params, :shop_id_param

  def authenticate_admin
		self.record.has_role?(:admin)
	end

	def authenticate_customer
		self.record.has_role?(:admin) || self.record.has_role?(:customer)
	end
end
