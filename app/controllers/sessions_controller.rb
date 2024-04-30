# frozen_string_literal: true

# This sessions controller handles login through the Shibboleth SSO system.
# Logging in through the development pathway will be handled through
# the DevSessionsController.

class SessionsController < ApplicationController
  SHIBBOLETH_LOGIN_URL = ENV.fetch('SHIBBOLETH_LOGIN_URL', nil).freeze
  SHIBBOLETH_LOGOUT_URL = ENV.fetch('SHIBBOLETH_LOGOUT_URL', nil).freeze

  skip_before_action :authenticate_user!, only: %i[new shibboleth_callback destroy]
  skip_before_action :check_user_active, only: %i[new shibboleth_callback destroy]

  def new
    reset_session_and_cookies
    redirect_to "#{SHIBBOLETH_LOGIN_URL}?target=#{shibboleth_callback_url}"
  end

  def shibboleth_callback
    return if handle_shibboleth_callback_errors(request.env)

    shib_attributes = extract_shibboleth_attributes(request.env)

    handle_user_login(shib_attributes)
  end

  def destroy
    reset_session_and_cookies
    redirect_to SHIBBOLETH_LOGOUT_URL.to_s, notice: 'Logged out successfully'
  end

  private

  def handle_shibboleth_callback_errors(env)
    return handle_error(env['Shib-Error']) if env['Shib-Error']
    return handle_error('Login failed: Shibboleth attributes are nil.') if env['Shib-Attributes'].nil?

    false
  end

  def handle_user_login(shib_attributes)
    user = find_user(shib_attributes[:username])
    return handle_user_not_found unless user

    handle_successful_login(user)
  end

  def extract_shibboleth_attributes(env)
    env['Shib-Attributes']
  end

  def find_user(username)
    User.find_by(username:)
  end

  # Consolidated error handler for missing attributes or Shibboleth errors
  def handle_error(message)
    reset_session_and_cookies

    Rails.logger.error message
    redirect_to root_path, alert: message
    true
  end

  # Handles successful login by setting session and redirecting the user
  def handle_successful_login(user)
    session[:user_id] = user.id
    session[:last_seen] = Time.current

    redirect_user_based_on_status(user)
  end

  # Redirects the user based on their account status
  def redirect_user_based_on_status(user)
    if user.account_active
      redirect_to conservation_records_path, notice: 'Signed in successfully via Shibboleth'
    else
      redirect_to root_path, alert: 'Your account is not active.'
    end
  end

  # Handles the scenario where the user is not found in the system
  def handle_user_not_found
    reset_session_and_cookies
    redirect_to root_path, alert: 'Login failed: Username not found'
  end

  # Resets the session and cookies to log the user out
  # and clear any existing session data
  def reset_session_and_cookies
    session[:user_id] = nil
    session[:last_seen] = nil
    cookies.delete(:_conservation_session)
  end
end
