class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :no_valid_record


  def no_valid_record(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception.message, 404)), status: :not_found
  end
end
