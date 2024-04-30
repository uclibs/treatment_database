# frozen_string_literal: true

module AuthenticationHelper
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :check_user_active, if: :user_signed_in?
  end

  def admin?
    @current_user.role == 'admin'
  end

  private

  def reset_session_and_cookies
    reset_session
    cookies.to_hash.each_key do |key|
      cookies.delete(key)
    end
  end

  def handle_successful_login(user, notice_message)
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    redirect_user_based_on_status(user, notice_message)
  end

  def redirect_user_based_on_status(user, notice_message)
    if user.account_active
      redirect_to conservation_records_path, notice: notice_message
    else
      redirect_to root_path, alert: 'Your account is not active.'
    end
  end

  def authenticate_user!
    return if user_signed_in?

    redirect_to root_path, alert: 'You need to sign in before continuing.'
  end

  def check_user_active
    return if current_user.account_active

    flash[:alert] = 'Your account is not active.'
    redirect_to root_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end
end
