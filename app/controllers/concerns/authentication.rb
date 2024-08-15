# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :check_user_active, if: :user_signed_in?
  end

  def admin?
    @current_user.role == 'admin'
  end

  private

  def authenticate_user!
    return if user_signed_in?

    redirect_to new_session_path, alert: 'You need to sign in before continuing.'
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
