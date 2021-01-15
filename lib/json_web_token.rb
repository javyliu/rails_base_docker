class JsonWebToken
  class << self
    def encode(playload, exp = 24.hours.from_now)
      Rails.logger.debug "====#{exp.to_i}===="
      playload[:exp]= exp.to_i
      secret_key_base = Rails.application.credentials.secret_key_base
      JWT.encode(playload, secret_key_base)
    end

    def decode(token)
      secret_key_base = Rails.application.credentials.secret_key_base
      body = JWT.decode(token, secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
      Rails.logger.debug e.message
      nil
    rescue => e
      Rails.logger.debug e.message
      nil
    end
  end
end
