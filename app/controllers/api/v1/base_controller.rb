class Api::V1::BaseController < ActionController::Base
  respond_to :json

  def default_format_json
    request.format = :json unless params[:format]
  end

  def error!(message, status)
    render json: { error: message }, status: status
  end

end