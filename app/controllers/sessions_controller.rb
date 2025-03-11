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
    # Respond with JSON to provide the Shibboleth logout URL to the frontend
    render json: { shibboleth_logout_url: shibboleth_logout_url }, status: :ok
  end

  private

  def shibboleth_logout_url
    'https://libappstest.libraries.uc.edu/Shibboleth.sso/Logout'
  end
end
