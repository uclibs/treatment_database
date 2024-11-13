# app/controllers/dev_sessions_controller.rb
class DevSessionsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :check_user_active
  skip_before_action :validate_session_timeout

  def new
    # Renders the development login form
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      reset_session_and_cookies
      session[:user_id] = user.id
      session[:last_seen] = Time.current
      Rails.logger.info "User #{user.email} logged in successfully (Development)."
      redirect_to params[:target] || root_path, notice: 'Signed in successfully (Development).'
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    reset_session_and_cookies
    redirect_to root_path, notice: 'Signed out successfully (Development).'
  end
end
