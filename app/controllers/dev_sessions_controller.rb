# frozen_string_literal: true

class DevSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create destroy]
  skip_before_action :check_user_active, only: %i[new create destroy]
  skip_before_action :validate_session_timeout, only: %i[new create destroy]

  def new
    redirect_to params[:target] || root_path if user_signed_in?
  end

  def create
    username = params[:username].strip.downcase
    user = User.find_by(username: username)

    return handle_failed_login unless user

    handle_successful_login(user)
  end

  def destroy
    reset_session_and_cookies
    redirect_to root_path, notice: 'Signed out successfully. (Development)'
  end

  private

  def handle_successful_login(user)
    reset_session_and_cookies
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    redirect_to params[:target] || conservation_records_path, notice: 'Signed in successfully. (Development)'
  end

  def handle_failed_login
    flash.now[:alert] = 'Invalid username'
    render :new
  end
end
