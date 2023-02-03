class Cart < ApplicationRecord
  STATUS = { pending: 0, done: 1 }.freeze
  belongs_to :user
  has_many :cart_items, dependent: :destroy
end
