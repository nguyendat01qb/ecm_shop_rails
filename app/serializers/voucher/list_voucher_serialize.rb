class Voucher::ListVoucherSerialize < ActiveModel::Serializer
  attributes :id, :name, :cost, :max_user, :discount_mount, :apply_amount, :type_voucher, :status, :start_time, :end_time

  def discount_mount
    "$ #{object.discount_mount}"
  end

  def apply_amount
    "$ #{object.apply_amount}"
  end

  def start_time
    object.start_time.strftime("%H:%M %d/%m/%Y")
  end

  def end_time
    object.end_time.strftime("%H:%M %d/%m/%Y")
  end
end
