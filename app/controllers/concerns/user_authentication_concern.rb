# frozen_string_literal: true

module UserAuthenticationConcern
  extend ActiveSupport::Concern

  # **Authentication Methods**

  def authenticate_user!
    return if user_signed_in?

    if Rails.env.development? || Rails.env.test?
      redirect_to dev_login_path(target: request.fullpath)
    else
      redirect_to login_path(target: request.fullpath)
    end
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

  # def handle_successful_login(user, notice_message)
  #   reset_session
  #   session[:user_id] = user.id
  #   session[:last_seen] = Time.current
  #   Rails.logger.info "User #{user.username} logged in successfully."
  #   redirect_user_based_on_status(user, notice_message)
  # end
  #
  # def redirect_user_based_on_status(user, notice_message)
  #   if user.account_active
  #     redirect_to conservation_records_path, notice: notice_message
  #   else
  #     redirect_to root_path, alert: 'Your account is not active.'
  #   end
  # end
end
