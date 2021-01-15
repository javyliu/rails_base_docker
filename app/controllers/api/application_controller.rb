module Api
  class ApplicationController < ActionController::API

    before_action :authenticate_request
    attr_reader :current_api_user


    private
    #如果header中 Authorization 验证通过，即会返回该用户
    #headers['Authorization']中的格式为 {user_id: xx, exp:xxx}
    def authenticate_request
      command = AuthorizeApiRequest.call(request.headers)
      Rails.logger.debug "-----------"
      Rails.logger.debug command.errors

      @current_api_user = command.result

      render json: {error: command.errors.full_messages }, status: :unauthorized unless command.success?
    end

  end


end
