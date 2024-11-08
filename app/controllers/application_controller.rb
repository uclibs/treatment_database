# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthenticationHelper
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :check_user_active, if: :user_signed_in?
  before_action :validate_session_timeout, if: :user_signed_in?

  protect_from_forgery with: :exception
  # include SamlHelper

  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_auth_token

  rescue_from ActiveRecord::RecordNotFound, with: :render404

  private

  def handle_invalid_auth_token
    # Redirect to a safe page like the homepage and show a flash message
    redirect_to root_path, alert: 'Your session has expired. Please sign in again.'
  end

  def render404
    respond_to do |format|
      format.html { render template: 'errors/not_found', status: :not_found }
      format.json { render json: { error: 'Not Found' }, status: :not_found }
    end
  end
end
