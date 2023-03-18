class Admin::VouchersController < Admin::BaseAdminController
  before_action :set_voucher, only: %i[show edit update destroy]

  def index; end

  def show; end

  def new
    @voucher = Voucher.new
  end

  def create
    create, @voucher, message = Admin::Vouchers::CreateService.call(voucher_params)

    if create
      flash[:success] = message
      redirect_to admin_vouchers_url
    else
      flash[:danger] = message
      render :new
    end
  end

  def edit; end

  def update
    update, message = Admin::Vouchers::UpdateService.call(@voucher, voucher_params)

    status = update ? :success : :danger
    flash[status] = message
    render :edit
  end

  def destroy
    destroy, message = Admin::Vouchers::DestroyService.call(@voucher)

    status = destroy ? :success : :danger
    flash[status] = message
    redirect_to admin_vouchers_url
  end

  def export_csv
    csv = Admin::Vouchers::ExportCsvService.new(Voucher.all, Voucher::CSV_ATTRIBUTES)
    respond_to do |format|
      format.csv { send_data csv.perform, filename: "vouchers-#{Date.current}.csv" }
    end
  end

  private

  def set_voucher
    @voucher = Voucher.find(params[:id])
  end

  def voucher_params
    params.require(:voucher).permit(
      :code, :cost, :name,
      :max_user,
      :discount_mount,
      :apply_amount,
      :type_voucher,
      :status,
      :start_time, :end_time,
      :description
    )
  end
end
