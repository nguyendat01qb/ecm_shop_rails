class Order < ApplicationRecord
  STATUSES = { pending: 0, failed: 1, paid: 2, approved: 3, canceled: 4, shipping: 5, delivering: 6, success: 7 }.freeze
  enum payment_gateway: { stripe: 0, pay_on_delivery: 1, momo: 2, vnpay: 3, paypal: 4, cod: 5 }

  has_many :order_items, dependent: :destroy

  belongs_to :address
  belongs_to :user

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end
end
