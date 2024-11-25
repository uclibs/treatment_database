# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new destroy]
  skip_before_action :check_user_active, only: %i[new destroy]
  skip_before_action :validate_session_timeout, only: %i[new destroy]

  def new
    if user_signed_in?
      redirect_to params[:target] || root_path
    else
      process_shibboleth_login
    end

    # Explicitly prevent rendering a view
    head :ok unless performed?
  end

  def destroy
    reset_session_and_cookies
    redirect_to logout_url
    # redirect_to root_path, notice: 'Signed out successfully'
  end

  # def shibboleth_sp_logout_url
  #   "#{ENV['SHIBBOLETH_LOGOUT_URL']}?RelayState=#{root_url}" || '/Shibboleth.sso/Logout'
  #
  # end
end
