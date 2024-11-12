# frozen_string_literal: true

class SessionsController < ApplicationController
  include AuthenticationConcern
  # include SamlHelper

  skip_before_action :authenticate_user!, only: %i[new destroy]
  skip_before_action :check_user_active, only: %i[new destroy]
  skip_before_action :validate_session_timeout, only: %i[new destroy]

  def new
    # Redirect to a protected URL to trigger Shibboleth authentication
    redirect_to shibboleth_login_url
  end

  def destroy
    reset_session_and_cookies
    redirect_to shibboleth_logout_url, notice: 'Signed out successfully'
  end

  private

  def shibboleth_login_url
    # Redirect to a protected path to initiate Shibboleth authentication
    shibboleth_login_url = ENV.fetch('SHIBBOLETH_LOGIN_URL') { raise 'SHIBBOLETH_LOGIN_URL is not set' }
    "#{shibboleth_login_url}?target=#{CGI.escape(conservation_records_path)}"
  end

  def shibboleth_logout_url
    shibboleth_logout_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL') { raise 'SHIBBOLETH_LOGOUT_URL is not set' }
    "#{shibboleth_logout_url}?target=#{CGI.escape(root_url)}"
  end
end
