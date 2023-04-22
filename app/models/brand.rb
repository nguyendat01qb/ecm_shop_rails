class Brand < ApplicationRecord
  extend FriendlyId
  extend SearchKeyword::QuerySearch
  CSV_ATTRIBUTES = %w[title slug created_at updated_at].freeze

  friendly_id :title, use: :slugged

  has_many :products

  validates :title, presence: true, length: { minimum: 2, maximum: 30 }, uniqueness: true

  scope :include_products, -> { includes(:products) }
end
