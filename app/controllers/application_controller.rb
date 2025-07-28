class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:admin])
    devise_parameter_sanitizer.permit(:account_update, keys: [:admin])
  end

  def ensure_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end

  def ensure_customer
    redirect_to root_path, alert: 'Access denied.' unless current_user&.customer?
  end
end