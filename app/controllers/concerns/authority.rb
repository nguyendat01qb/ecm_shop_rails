module Authority
  def verify_authority
    valid = check_permissions
    render_permission_error unless valid
  rescue NameError, NoMethodError => e
    true
  rescue StandardError => e
    Slack::PushErrorService.new({ error: e, detail: e.backtrace[0..5].join('\n') }, 'Error authority').push
    logger = Logger.new(Rails.root.join('log', 'authority.log'))
    logger.error("#{e.message} : #{e.backtrace[0..5].join('\n')}")
    true
  end

  def check_permissions
    policy_class.new(current_user, params, processing_shop_id).send(policy_action)
  end

  def policy_class
    (controller.classify + 'Policy').constantize
  end

  def policy_action
    "#{action}?"
  end

  def redis_policy
    @redis_policy ||= RedisStorage::Cache.new(prefix: :policy, ex: 24.hours)
  end

  def policy_id
    @policy_id ||=
      if processing_shop_id.present?
        "#{current_company_id}/#{current_user_id}/#{controller}/#{action}/#{processing_shop_id}"
      else
        "#{current_company_id}/#{current_user_id}/#{controller}/#{action}"
      end
  end

  def value_redis
    value = redis_policy.load(id: policy_id)
    ['true', true].include?(value) if value.present?
  end

  def request_id
    @request_id ||= params[:id] || params[:request_id]
  end

  def processing_shop_id
    @processing_shop_id ||= params[:shop_id]
  end

  def action
    @action ||= params[:action]
  end

  def controller
    @controller ||= params[:controller]
  end

  def multishop?
    params[:shop_ids].present? || params[:main_shops].present? || params[:shops].present?
  end
end
