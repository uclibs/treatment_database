# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController # rubocop:disable Style/ClassAndModuleChildren
  # before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  # We use this to allow custom (not default to devise) :display_name variable on user object.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:display_name])
  end

  def new
    flash[:notice] = 'Contact admin to request account'
    redirect_to new_user_session_path and return
  end
end
