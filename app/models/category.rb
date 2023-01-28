class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :parent, class_name: 'Category', optional: true, foreign_key: :category_id
  has_many :childs, class_name: 'Category', dependent: :destroy
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories, dependent: :destroy

  validates :title, presence: true, length: { minimum: 1, maximum: 50 }
  validates :meta_title, presence: true, length: { minimum: 1, maximum: 50 }
  validates :content, presence: true, length: { minimum: 1, maximum: 500 }

  scope :is_parent, -> { where category_id: nil }
  scope :include_categories, -> { includes(:childs) }
end
