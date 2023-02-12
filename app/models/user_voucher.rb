class UserVoucher < ApplicationRecord
  STATUSES = { normal: 0, applying: 1, rejected: 2 }

  belongs_to :user
  belongs_to :voucher

  scope :applying, -> { find_by(status: STATUSES[:applying]) }
  scope :by_voucher_id_and_status, ->(voucher_id, status) { find_by(voucher_id: voucher_id, status: status) }
end
