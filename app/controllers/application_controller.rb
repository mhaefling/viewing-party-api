class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :no_valid_record
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from StandardError, with: :party_length_error


  def no_valid_record(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception.message, 404)), status: :not_found
  end

  def invalid_record(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception.message, 422)), status: :unprocessable_entity
  end

  def party_length_error(exception)
    render json: ErrorSerializer.format_error(ErrorMessage.new(exception.message, 422)), status: :unprocessable_content
  end
end
