# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new destroy]
  skip_before_action :check_user_active, only: %i[new destroy]
  skip_before_action :validate_session_timeout, only: %i[new destroy]

  def new
    if user_signed_in?
      Rails.logger.debug "User is already signed in: #{current_user.username}"
      redirect_to params[:target] || root_path
    else
      Rails.logger.debug 'User not signed in. Attempting to process Shibboleth login.'
      process_shibboleth_login
    end
  end


  def destroy
    reset_session_and_cookies
    redirect_to shibboleth_logout_url, notice: 'Signed out successfully'
  end

  private

  def shibboleth_logout_url
    shib_logout_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL') { raise 'SHIBBOLETH_LOGOUT_URL is not set' }
    "#{shib_logout_url}?return=#{CGI.escape(root_url)}"
  end

  def shibboleth_attributes_present?
    request.headers['X-Shib-User'].present?
  end

  def process_shibboleth_login
    if shibboleth_attributes_present?
      Rails.logger.debug 'Shibboleth attributes are present.'

      # Extract the portion before the '@' sign
      full_username = request.headers['X-Shib-User']
      match = full_username.match(/^([^@]+)/)
      username = match[1] if match

      Rails.logger.debug "Extracted username: #{username}"

      user = User.find_by(username: username)

      if user
        handle_successful_login(user)
        redirect_to params[:target] || conservation_records_path, info: "Welcome back, #{user.display_name}"
      else
        Rails.logger.error "User with username #{username} not found."
        redirect_to root_path, alert: 'Sign in failed: User not found.'
      end
    else
      Rails.logger.error 'Shibboleth attributes not present. Cannot authenticate user.'
      redirect_to root_path, alert: 'Authentication failed: Shibboleth attributes not present.'
    end
  end


  def handle_successful_login(user)
    reset_session_and_cookies
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    Rails.logger.info "User #{user.username} logged in successfully."
  end
end
