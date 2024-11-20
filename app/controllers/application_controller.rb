# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include AuthenticationConcern

  helper_method :current_user, :user_signed_in?

  before_action :authenticate_user!
  before_action :check_user_active, if: :user_signed_in?
  before_action :validate_session_timeout, if: :user_signed_in?
  after_action :expose_last_seen_for_tests, if: -> { Rails.env.test? }

  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_auth_token
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  private

  def handle_invalid_auth_token
    redirect_to root_path, alert: 'Your session has expired. Please sign in again.'
  end

  def render404
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: :not_found }
      format.json { render json: { error: 'Not Found' }, status: :not_found }
    end
  end

  def expose_last_seen_for_tests
    response.headers['X-Last-Seen'] = session[:last_seen].to_s if session[:last_seen]
  end
end
