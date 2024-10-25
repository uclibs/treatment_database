# frozen_string_literal: true

class SessionsController < ApplicationController
  include AuthenticationHelper
  include SamlHelper

  skip_before_action :authenticate_user!, only: %i[new shibboleth_callback destroy metadata]
  skip_before_action :check_user_active, only: %i[new shibboleth_callback destroy metadata]

  def new
    reset_session_and_cookies
    redirect_to shibboleth_login_url
  end

  def shibboleth_callback
    return if handle_shibboleth_callback_errors(request.env)

    shib_attributes = extract_shibboleth_attributes(request.env)
    handle_user_login(shib_attributes)
  end

  def destroy
    reset_session_and_cookies
    redirect_to shibboleth_logout_url, notice: 'Signed out successfully'
  end

  def metadata
    render template: 'sessions/metadata', formats: [:xml]
  end

  private

  def handle_shibboleth_callback_errors(env)
    if env['Shib-Error']
      handle_error(env['Shib-Error'])
    elsif env['Shib-Attributes'].nil?
      handle_error('Sign in failed: Shibboleth attributes are nil.')
    else
      false
    end
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
    User.find_by(username: username)
  end

  def handle_error(message)
    reset_session_and_cookies
    Rails.logger.error message
    redirect_to root_path, alert: message
    true
  end

  def handle_successful_login(user)
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    redirect_user_based_on_status(user)
  end

  def redirect_user_based_on_status(user)
    if user.account_active
      redirect_to conservation_records_path, notice: 'Signed in successfully via Shibboleth'
    else
      redirect_to root_path, alert: 'Your account is not active.'
    end
  end

  def handle_user_not_found
    reset_session_and_cookies
    redirect_to root_path, alert: 'Sign in failed: User not found'
  end
end
