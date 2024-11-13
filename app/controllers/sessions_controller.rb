# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new shibboleth_callback destroy]
  skip_before_action :check_user_active, only: %i[new shibboleth_callback destroy]
  skip_before_action :validate_session_timeout, only: %i[new shibboleth_callback destroy]

  def new
    if user_signed_in?
      redirect_to params[:target] || root_path
    else
      redirect_to shibboleth_login_url
    end
  end

  def shibboleth_callback
    if shibboleth_attributes_present?
      process_shibboleth_login
      redirect_to params[:target] || conservation_records_path
    else
      Rails.logger.error 'Shibboleth attributes not present. Cannot authenticate user.'
      redirect_to root_path, alert: 'Authentication failed: Shibboleth attributes not present.'
    end
  end

  def destroy
    reset_session_and_cookies
    redirect_to shibboleth_logout_url, notice: 'Signed out successfully'
  end

  private

  def shibboleth_login_url
    shibboleth_login_url = ENV.fetch('SHIBBOLETH_LOGIN_URL') { raise 'SHIBBOLETH_LOGIN_URL is not set' }
    "#{shibboleth_login_url}?target=#{CGI.escape(callback_url)}"
  end

  def shibboleth_logout_url
    shibboleth_logout_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL') { raise 'SHIBBOLETH_LOGOUT_URL is not set' }
    "#{shibboleth_logout_url}?target=#{CGI.escape(root_url)}"
  end

  def callback_url
    url_for(action: 'shibboleth_callback', only_path: false)
  end

  def shibboleth_attributes_present?
    request.env['uid'].present?
  end

  def process_shibboleth_login
    username = request.env['uid']
    if username.blank?
      Rails.logger.error 'Shibboleth username attribute not present in request.env.'
      redirect_to root_path, alert: 'Authentication failed: Username attribute not present.'
      return
    end

    user = User.find_by(username: username)
    if user
      handle_successful_login(user)
    else
      Rails.logger.error "User with UID #{username} not found."
      redirect_to root_path, alert: 'Sign in failed: User not found.'
    end
  end

  def handle_successful_login(user)
    reset_session_and_cookies
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    Rails.logger.info "User #{user.username} logged in successfully."
  end
end
