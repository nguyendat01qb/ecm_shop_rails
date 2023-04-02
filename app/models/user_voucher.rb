class UserVoucher < ApplicationRecord
  STATUSES = { normal: 0, applying: 1, applied: 2, rejected: 3 }

  belongs_to :user
  belongs_to :voucher

  scope :applying, -> { where(status: STATUSES[:applying]) }
  scope :by_voucher_id_and_status, ->(voucher_id, status) { find_by(voucher_id: voucher_id, status: status) }
end
