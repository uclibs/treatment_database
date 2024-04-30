# frozen_string_literal: true

# app/controllers/dev_sessions_controller.rb
class DevSessionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_user_active

  def new
    # Render the development login form
  end

  def create
    user = authenticate_user

    if user
      handle_successful_login(user, 'Signed in successfully (Development).')
    else
      handle_failed_login
    end
  end

  def destroy
    reset_session_and_cookies
    redirect_to root_path, notice: 'Signed out successfully (Development).'
  end

  private

  def authenticate_user
    user = User.find_by(email: params[:email])
    user if user&.authenticate(params[:password])
  end

  def handle_failed_login
    flash.now[:alert] = 'Invalid email or password'
    render :new
  end
end
