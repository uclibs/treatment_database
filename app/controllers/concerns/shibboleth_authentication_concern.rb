# frozen_string_literal: true

module ShibbolethAuthenticationConcern
  extend ActiveSupport::Concern

  private

  def process_shibboleth_login
    username = find_shibboleth_username

    if username.blank?
      handle_missing_username
    else
      authenticate_user_with_username(username)
    end
  end

  def handle_missing_username
    log_missing_attribute_error
    redirect_to root_path, alert: 'Authentication failed: Username attribute not present.'
  end

  def authenticate_user_with_username(username)
    user = User.find_by(username: username)
    if user
      handle_successful_login(user, 'Signed in successfully.')
    else
      handle_user_not_found
    end
  end

  def shibboleth_attributes_present?
    attribute_names = %w[uid eppn REMOTE_USER]
    attribute_names.any? do |attr|
      request.env[attr].present? || request.env["HTTP_#{attr.upcase}"].present?
    end
  end

  def find_shibboleth_username
    attribute_names = %w[uid eppn REMOTE_USER]
    attribute_names.each do |attr|
      value = request.env[attr] || request.env["HTTP_#{attr.upcase}"]
      return value if value.present?
    end
    nil
  end

  def log_missing_attribute_error
    Rails.logger.error 'Shibboleth username attribute not present in request.env.'
  end

  def handle_user_not_found
    reset_session_and_cookies
    redirect_to root_path, alert: 'Sign in failed: User not found'
  end
end
