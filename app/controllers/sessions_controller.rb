# frozen_string_literal: true

class SessionsController < ApplicationController
  include AuthenticationConcern
  # include SamlHelper

  skip_before_action :authenticate_user!, only: %i[new destroy]
  skip_before_action :check_user_active, only: %i[new destroy]
  skip_before_action :validate_session_timeout, only: %i[new destroy]

  def new
    if user_signed_in?
      redirect_to params[:target] || root_path
    else
      redirect_to shibboleth_login_url
    end
  end

  def destroy
    reset_session_and_cookies
    redirect_to shibboleth_logout_url, notice: 'Signed out successfully'
  end

  private

  def shibboleth_login_url
    # Redirect to a protected path to initiate Shibboleth authentication
    shibboleth_login_url = ENV.fetch('SHIBBOLETH_LOGIN_URL') { raise 'SHIBBOLETH_LOGIN_URL is not set' }
    "#{shibboleth_login_url}?target=#{CGI.escape(callback_url)}"
  end

  def callback_url
    url_for(action: 'shibboleth_callback', only_path: false)
  end

  def shibboleth_callback
    if shibboleth_attributes_present?
      process_shibboleth_login
      redirect_to params[:target] || root_path
    else
      Rails.logger.error 'Shibboleth attributes not present. Cannot authenticate user.'

      Rails.logger.error 'request.env attributes are:'
      if request.env[attr].is_a?(Enumerable)
        request.env[attr].each do |attribute|
          Rails.logger.error attribute
        end
      else
        Rails.logger.error "No attributes found in request.env[#{attr}] or it is not iterable."
      end

      Rails.logger.error 'request.header items are:'
      if request.headers.is_a?(Enumerable)
        request.headers.each do |header_item|
          Rails.logger.error header_item
        end
      else
        Rails.logger.error "No attributes found in request.headers or it is not iterable. This message originates from sessions_controller/#shibboelth_callback"
      end
      redirect_to root_path, alert: 'Authentication failed: Shibboleth attributes not present.  This message originates from sessions_controller/#shibboelth_callback'
    end
  end

  def shibboleth_logout_url
    shibboleth_logout_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL') { raise 'SHIBBOLETH_LOGOUT_URL is not set' }
    "#{shibboleth_logout_url}?target=#{CGI.escape(root_url)}"
  end
end
