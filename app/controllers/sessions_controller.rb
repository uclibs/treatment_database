# frozen_string_literal: true

class SessionsController < ApplicationController
  include AuthenticationHelper
  # include SamlHelper

  skip_before_action :authenticate_user!, only: %i[new destroy]
  skip_before_action :check_user_active, only: %i[new destroy]

  def new
    # Redirect to a protected URL to trigger Shibboleth authentication
    redirect_to shibboleth_login_url
  end

  # def shibboleth_callback
  #   shib_attributes = extract_shibboleth_attributes(request)
  #   return handle_shib_error('Sign in failed: Shibboleth username is missing.') unless username_present?(shib_attributes)
  #
  #   handle_user_login(shib_attributes)
  # end

  def destroy
    reset_session_and_cookies
    redirect_to shibboleth_logout_url, notice: 'Signed out successfully'
  end

  # def metadata
  #   render template: 'sessions/metadata', formats: [:xml]
  # end

  private

  def shibboleth_login_url
    # Redirect to a protected path to initiate Shibboleth authentication
    shibboleth_login_url = ENV.fetch('SHIBBOLETH_LOGIN_URL') { raise 'SHIBBOLETH_LOGIN_URL is not set' }
    "#{shibboleth_login_url}?target=#{CGI.escape(conservation_records_path)}"
  end

  def shibboleth_logout_url
    shibboleth_logout_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL') { raise 'SHIBBOLETH_LOGOUT_URL is not set' }
    "#{shibboleth_logout_url}?target=#{CGI.escape(root_url)}"
  end

  # def handle_user_login(shib_attributes)
  #   user = User.find_by(username: shib_attributes[:username])
  #   return handle_user_not_found unless user
  #
  #   handle_successful_login(user, 'Signed in successfully.')
  # end

  # def handle_shib_error(message)
  #   reset_session_and_cookies
  #   Rails.logger.error message
  #   redirect_to root_path, alert: message
  # end
end
