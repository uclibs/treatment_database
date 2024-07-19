# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_paper_trail_whodunnit

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = exception.message
    redirect_to conservation_records_path
  end

  private

  def authenticate_user!
    return if user_signed_in?

    redirect_to root_path, notice: 'You must be logged in to access this page.'
  end

  def user_signed_in?
    session[:user_id].present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if user_signed_in?
  end

  helper_method :current_user, :user_signed_in?
end
