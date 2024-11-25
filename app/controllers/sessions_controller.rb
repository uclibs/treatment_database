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
    redirect_to shibboleth_logout_url
  end

  private

  def shibboleth_logout_url
    "/Shibboleth.sso/Logout?return=#{root_url}"
  end
end
