module PrivacyPolicy
  def render_permission_error
    render json: permission_error_message
  end

  def render_empty_shop_error
    render json: error_message(I18n.t('messages.errors.tightening.empty_shop'), [])
  end

  def shop_without_permission?(shop_id)
    manageable_shop_ids.exclude?(shop_id)
  end

  def manager_has_no_permission?(company_ids = [])
    company_ids.size != 1 || company_ids.first != current_company_id
  end

  def company_has_this_data?(instance_variable: nil)
    instance_variable && instance_variable.user&.company_id == current_company_id
  end

  def company_has_not_this_data?(instance_variable: nil)
    !company_has_this_data?(instance_variable: instance_variable)
  end

  def company_ids
    @company_ids ||= Set.new
  end

  def current_company_id
    @current_company_id ||= current_user.company_id
  end

  def current_user_id
    @current_user_id ||= current_user.id
  end

  def user_role
    @user_role ||= UserRole.new(current_user, { company: current_company })
  end

  def all_shops_in_company
    @all_shops_in_company ||= current_company.shops
  end
end
