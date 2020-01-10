# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = exception.message
    redirect_to root_url
  end 

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || conservation_records_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end
end
