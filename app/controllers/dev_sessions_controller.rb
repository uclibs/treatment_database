# frozen_string_literal: true

# This dev_sessions controller handles login through the development pathway.
# Logging in through the Shibboleth SSO system will be handled through
# the SessionsController. This controller is only available in development
# and test environments, and is not accessible in production because there
# are no routes for it.

class DevSessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create destroy]
  skip_before_action :check_user_active, only: %i[new create destroy]

  def new; end

  def create
    user = find_user
    if user_authenticated?(user)
      login_user(user)
    else
      handle_invalid_credentials
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully'
  end

  private

  def find_user
    User.find_by(email: params[:email])
  end

  def user_authenticated?(user)
    user&.authenticate(params[:password])
  end

  def login_user(user)
    session[:user_id] = user.id
    if user.account_active
      redirect_to conservation_records_path, notice: 'Signed in successfully'
    else
      redirect_to root_path, alert: 'Your account is not active.'
    end
  end

  def handle_invalid_credentials
    flash.now[:alert] = 'Invalid email or password'
    render :new
  end
end
