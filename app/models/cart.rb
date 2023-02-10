class Cart < ApplicationRecord
  STATUSES = { pending: 0, done: 1 }.freeze
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  scope :is_pending, -> { where(status: STATUSES[:pending]) }

  before_create :set_status

  private

  def set_status
    self.status = STATUSES[:pending]
  end
end
