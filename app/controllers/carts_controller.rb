class CartsController < ApplicationController
  def show
    @signed_in = cookies[:api_token].present?
  end
end
