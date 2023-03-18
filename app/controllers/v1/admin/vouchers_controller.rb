class V1::Admin::VouchersController < V1::Admin::BaseAuthController
  def load_vouchers
    page = params[:page].to_i
    per_page = 10
    vouchers = Voucher.all.select(:id, :name, :cost, :max_user, :discount_mount, :apply_amount, :type_voucher, :status,
                                  :start_time, :end_time).page(page).per(per_page)
    render json: success_message(
      I18n.t('messages.success.voucher.list_vouchers'),
      vouchers: ActiveModelSerializers::SerializableResource.new(
        vouchers,
        each_serializer: Voucher::ListVoucherSerialize
      ),
      total_page: vouchers.total_pages,
      per_page: per_page,
      page: page,
      total: vouchers.total_count
    )
  end
end
