# frozen_string_literal: true

# app/controllers/dev_sessions_controller.rb
class DevSessionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_user_active
  skip_before_action :validate_session_timeout

  def new
    # Renders the development login form
  end

  def create
    user = find_user_by_email(params[:email])

    if authenticate_dev_user(user, params[:password])
      handle_successful_login(user)
    else
      handle_failed_login
    end
  end

  def destroy
    reset_session_and_cookies
    redirect_to root_path, notice: 'Signed out successfully (Development).'
  end

  private

  def find_user_by_email(email)
    User.find_by(email: email)
  end

  def authenticate_dev_user(user, password)
    user&.authenticate(password)
  end

  def handle_successful_login(user)
    reset_session_and_cookies
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    Rails.logger.error "User #{user.email} logged in successfully (Development)."
    redirect_to params[:target] || root_path, notice: 'Signed in successfully (Development).'
  end

  def handle_failed_login
    flash.now[:alert] = 'Invalid email or password'
    render :new
  end
end
