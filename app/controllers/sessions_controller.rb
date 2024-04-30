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
    Rails.logger.debug 'Calling reset_session_and_cookies'
    reset_session_and_cookies
    Rails.logger.debug { "Redirecting to Shibboleth with callback URL: #{shibboleth_callback_url}" }
    redirect_to "#{SHIBBOLETH_LOGIN_URL}?target=#{shibboleth_callback_url}"
  end

  def shibboleth_callback
    log_shibboleth_callback

    return if handle_shibboleth_callback_errors(request.env)

    shib_attributes = extract_shibboleth_attributes(request.env)

    handle_user_login(shib_attributes)
  end

  def destroy
    Rails.logger.debug { "Logging out of session ID: #{session[:user_id]}" }
    reset_session_and_cookies
    Rails.logger.debug { "Redirecting to #{SHIBBOLETH_LOGOUT_URL}" }
    redirect_to SHIBBOLETH_LOGOUT_URL.to_s, notice: 'Logged out successfully'
  end

  private

  def log_shibboleth_callback
    Rails.logger.info 'Shibboleth callback hit'
    Rails.logger.debug { "Request environment: #{request.env.inspect}" }
  end

  def handle_shibboleth_callback_errors(env)
    return handle_error(env['Shib-Error']) if env['Shib-Error']
    return handle_error('Login failed: Shibboleth attributes are nil.') if env['Shib-Attributes'].nil?

    false
  end

  def handle_user_login(shib_attributes)
    user = find_user(shib_attributes[:username])
    return handle_user_not_found(shib_attributes[:username]) unless user

    handle_successful_login(user)
  end

  def extract_shibboleth_attributes(env)
    Rails.logger.info "Shibboleth attributes: #{env['Shib-Attributes'].inspect}"
    env['Shib-Attributes']
  end

  def find_user(username)
    Rails.logger.info "Looking up user by username: #{username}"
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
    Rails.logger.debug { "Logging in user: #{user.inspect}" }
    Rails.logger.debug { "Setting session[:user_id] to #{user.id}" }
    session[:user_id] = user.id
    Rails.logger.debug { "Setting session[:last_seen] to #{Time.current}" }
    session[:last_seen] = Time.current

    redirect_user_based_on_status(user)
  end

  # Redirects the user based on their account status
  def redirect_user_based_on_status(user)
    if user.account_active
      Rails.logger.debug { 'User is active, redirecting to conservation_records_path' }
      redirect_to conservation_records_path, notice: 'Signed in successfully via Shibboleth'
    else
      Rails.logger.debug { 'User is not active, redirecting to root_path' }
      redirect_to root_path, alert: 'Your account is not active.'
    end
  end

  # Handles the scenario where the user is not found in the system
  def handle_user_not_found(username)
    Rails.logger.debug { "User not found: #{username}, clearing session and cookies and redirecting to root_path" }
    reset_session_and_cookies
    redirect_to root_path, alert: 'Login failed: Username not found'
  end
end
