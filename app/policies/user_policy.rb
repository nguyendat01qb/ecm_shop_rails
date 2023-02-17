class UserPolicy < BasePolicy
	def index?
		authenticate_admin
	end

	def admin?
		authenticate_admin
	end

	def load_admins?
		authenticate_admin
	end

	def load_users?
		authenticate_admin
	end

	def load_categories?
		authenticate_admin
	end

	def load_products?
		authenticate_admin
	end

	def load_brands?
		authenticate_admin
	end

	def show?
		authenticate_admin
	end

	def new?
		authenticate_admin
	end

	def create?
		authenticate_admin
	end

	def edit?
		authenticate_admin
	end

	def update?
		authenticate_admin
	end

	def destroy?
	  authenticate_admin
	end

	def select_attribute?
		authenticate_customer
	end

	def get_product_cart?
		authenticate_customer
	end

	def get_order?
		authenticate_customer
	end

	def voucher?
		authenticate_customer
	end

	def check_cart?
		authenticate_customer
	end

	def address?
		authenticate_customer
	end

	def success?
		authenticate_admin
	end

	def submit?
		authenticate_admin
	end

	def export_csv?
		authenticate_admin
	end

	def export_admin_csv?
		authenticate_admin
	end
end
