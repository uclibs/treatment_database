# frozen_string_literal: true

module UserAuthenticationConcern
  extend ActiveSupport::Concern

  private

  def authenticate_user!
    redirect_to root_path, alert: 'You must be signed in to access this page.' unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    return nil if Rails.env.test? && request.headers['X-Test-Invalid-User']

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def check_user_active
    return if current_user&.account_active?

    reset_session_and_cookies
    redirect_to root_path, alert: 'Your account is not active.'
  end

  def admin?
    @current_user.role == 'admin'
  end
end
