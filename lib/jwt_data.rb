require 'jwt'
class JwtData
  ALGORITHM = 'HS256'.freeze
  class << self
    def encode(payload)
      JWT.encode(
        payload,
        auth_secret,
        ALGORITHM
      )
    end

    def decode(token)
      JWT.decode(token,
                 auth_secret,
                 true,
                 algorithm: ALGORITHM).first
    rescue StandardError
      ''
    end

    def encode64(payload)
      Base64.encode64(JSON.dump(payload))
    end

    def decode64(token)
      JSON.parse(Base64.decode64(token))
    rescue StandardError
      ''
    end

    def auth_secret
      Settings.hmac_secret
    end
  end
end
