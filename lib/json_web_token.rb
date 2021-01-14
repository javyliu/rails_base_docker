class JsonWebToken
  class << self
    def encode(playload, expire = 24.hours.from_now)
      playload[:expire]= expire.to_i
      secret_key_base = Rails.application.credentials.secret_key_base
      JWT.encode(playload, secret_key_base)
    end


    def decode(token)
      secret_key_base = Rails.application.credentials.secret_key_base
      body = JWT.decode(token, secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil

    end
  end
end
