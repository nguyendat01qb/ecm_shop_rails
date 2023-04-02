class Client::Checkout::MomoService < ApplicationService
  def initialize(user, order)
    @user = user
    @order = order
  end

  def call
    endpoint = env_momo[:MOMO_END_POINT]
    partner_code = env_momo[:MOMO_PARTNER_CODE]
    access_key = env_momo[:MOMO_ACCESS_KEY]
    secret_key = env_momo[:MOMO_SECRET_KEY]
    order_info = 'pay with MoMo'
    redirect_url = 'http://localhost:3000/'
    ipn_url = 'https://4b4e-42-116-183-132.ap.ngrok.io/webhook/momo'
    amount = (order.total * 23_000).to_i.to_s
    order_id = order.token
    request_id = SecureRandom.uuid
    request_type = 'payWithMethod'
    extra_data = ''

    raw_signature = "accessKey=#{access_key}&amount=#{amount}&extraData=#{extra_data}&ipnUrl=#{ipn_url}" +
                    "&orderId=#{order_id}&orderInfo=#{order_info}&partnerCode=#{partner_code}" +
                    "&redirectUrl=#{redirect_url}&requestId=#{request_id}&requestType=#{request_type}"

    signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret_key, raw_signature)

    json_request_to_momo = {
      partnerCode: partner_code, partnerName: 'Test', storeId: 'MomoTestStore', requestId: request_id,
      amount: amount, orderId: order_id, orderInfo: order_info, redirectUrl: redirect_url,
      ipnUrl: ipn_url, lang: 'vi', extraData: extra_data, requestType: request_type, signature: signature
    }

    uri = URI.parse(endpoint)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(uri.path)
    request.add_field('Content-Type', 'application/json')
    request.body = json_request_to_momo.to_json

    response = http.request(request)
    result = JSON.parse(response.body)
    result['payUrl']
  end

  private

  def env_momo
    Rails.application.credentials.momo
  end

  attr_accessor :user, :order
end
