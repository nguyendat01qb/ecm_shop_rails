class User < ApplicationRecord
  CSV_ATTRIBUTES = %w[name phone gender is_admin email created_at updated_at sign_in_count].freeze
  extend FriendlyId
  friendly_id :name, use: :slugged
  rolify

  after_initialize :set_default_role

  has_many :comments, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :user_vouchers, dependent: :destroy
  has_many :vouchers, through: :user_vouchers, dependent: :destroy
  has_many :orders, dependent: :destroy

  has_many :carts, dependent: :destroy
  has_one_attached :avatar

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :trackable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  validates :password, password: true, unless: -> { from_omniauth? }, on: :create
  validates :phone, phone_number: true, presence: true, unless: -> { from_omniauth? }
  validates :name, presence: true, length: { minimum: 6, maximum: 30 }, unless: -> { from_omniauth? }
  validates :email, presence: true, uniqueness: true

  scope :has_role_admin, -> { where(is_admin: true) }

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def generate_token
    api_token = User.new_token
    update_attribute(:api_token_digest, api_token)
    api_token
  end

  def display_image
    avatar.variant resize_to_limit: [300, 200]
  end

  def self.from_omniauth(auth)
    result = User.find_by(email: auth.info.email)
    return result if result

    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name.split('@').first
      # user.image = auth.info.image
      user.uid = auth.uid
      user.provider = auth.provider
      user.skip_confirmation!
    end
  end

  def current_admin
    has_role? :admin
  end

  def is_admin?
    user_role.admin?
  end

  private

  def set_default_role
    self.roles ||= :user
  end

  def from_omniauth?
    provider && uid
  end

  def user_role
    @user_role ||= UserRole.new(self)
  end
end
