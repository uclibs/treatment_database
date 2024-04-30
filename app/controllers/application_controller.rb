# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Authentication

  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_url
  end

  rescue_from ActiveRecord::RecordNotFound, with: :render404

  helper_method :current_user, :user_signed_in?, :authenticate_user!, :admin?

  def admin?
    @current_user.role == 'admin'
  end

  private

  def render404
    respond_to do |format|
      format.html { render file: Rails.public_path.join('404.html'), status: :not_found, layout: false }
      format.json { render json: { error: 'Not Found' }, status: :not_found }
    end
  end
end
