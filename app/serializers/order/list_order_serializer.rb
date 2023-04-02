class Order::ListOrderSerializer < ActiveModel::Serializer
  attributes :id, :token, :status, :payment_gateway, :total, :created_at

  def status
    case object.status
    when Order::STATUSES[:failed]
      'FAILED'
    when Order::STATUSES[:paid]
      'PAID'
    when Order::STATUSES[:canceled]
      'CANCELED'
    when Order::STATUSES[:approved]
      'APPROVED'
    when Order::STATUSES[:shipping]
      'SHIPPING'
    when Order::STATUSES[:delivering]
      'DELIVERING'
    when Order::STATUSES[:success]
      'SUCCESS'
    else
      'PENDING'
    end
  end

  def created_at
    object.created_at.strftime('%H:%M %d/%m/%Y')
  end
end
