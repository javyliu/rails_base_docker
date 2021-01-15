module Api
  class ApplicationController < ActionController::API

    before_action :authenticate_request
    attr_reader :current_api_user


    private
    def authenticate_request
      command = AuthorizeApiRequest.call(request.headers)
      Rails.logger.debug "-----------"
      Rails.logger.debug command.errors

      @current_api_user = command.result

      render json: {error: command.errors.full_messages }, status: :unauthorized unless command.success?
    end

  end


end
