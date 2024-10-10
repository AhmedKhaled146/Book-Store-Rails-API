class ApplicationController < ActionController::API

  include Pundit

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name username email password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name])
  end

  private

  def pagination_meta(records)
    {
      current_page: records.current_page,
      next_page: records.next_page,
      prev_page: records.prev_page,
      total_pages: records.total_pages,
      total_count: records.total_count
    }
  end

  def render_errors(object, message = "An error occurred")
    render json: {
      errors: object.errors,
      status: :unprocessable_entity,
      message: message
    }, status: :unprocessable_entity
  end

  def record_not_found(resource = "Record")
    render json: {
      errors: "#{resource} not found",
      status: :not_found,
      message: "Could not find the requested category"
    }, status: :not_found
  end

  def user_not_authorized
    render json: {
      status: { code: 403, message: "You are not authorized to perform this action." }
    }, status: :forbidden
  end

end
