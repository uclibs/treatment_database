# frozen_string_literal: true

module UserAuthenticationConcern
  extend ActiveSupport::Concern

  # **Authentication Methods**

  def authenticate_user!
    return if user_signed_in?

    redirect_to root_path, alert: 'Please sign in to access this page.'
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def check_user_active
    return if current_user&.account_active

    flash[:alert] = 'Your account is not active.'
    redirect_to root_path
  end

  def admin?
    current_user&.role == 'admin'
  end
end
