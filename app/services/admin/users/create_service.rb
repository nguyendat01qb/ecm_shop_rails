class Admin::Users::CreateService < ApplicationService
  def initialize(user_params)
    @user_params = user_params
    @role = user_params[:roles]
  end

  def call
    user = User.new(user_params.except(:roles))
    user.skip_confirmation!
    if user.avatar.blank?
      user.avatar.attach({ io: File.open(Rails.root + 'app/assets/images/admin/avatars/user.jpg'),
                           filename: 'user.jpg' })
    end
    create = user.save
    message = create ? 'User was successfully created.' : 'User was failure created.'

    add_role(user) if create

    [create, user, message]
  end

  private

  attr_accessor :user_params, :role

  def add_role(user)
    role == 'admin' ? user.add_role(:admin) : user.add_role(:customer)
  end
end
