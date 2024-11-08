# frozen_string_literal: true

module AuthenticationHelper
  extend ActiveSupport::Concern

  def admin?
    current_user&.role == 'admin'
  end

  private

  def validate_session_timeout
    session_timeout_duration = 10.hours

    if session_expired?(session_timeout_duration)
      expire_session
    else
      session[:last_seen] = Time.current
    end
  end

  def session_expired?(timeout_duration)
    return true unless session[:last_seen]

    # Calculate whether the last_seen time is older than the allowed timeout duration
    session[:last_seen] < Time.current - timeout_duration
  end

  def expire_session
    reset_session
    redirect_to root_path, alert: 'Your session has expired. Please sign in again.'
  end

  def reset_session_and_cookies
    reset_session
    # Preserve Shibboleth-SP cookies to avoid disrupting the authentication process
    shibboleth_cookies = ['_shibsession_', '_shibstate_']
    cookies_to_preserve = cookies.keys.select do |key|
      shibboleth_cookies.any? { |shib_cookie| key.start_with?(shib_cookie) }
    end
    cookies.each_key do |key|
      cookies.delete(key, domain: :all) unless cookies_to_preserve.include?(key)
    end
  end

  def handle_successful_login(user, notice_message)
    reset_session
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    Rails.logger.info "User #{user.username} logged in successfully."
    redirect_user_based_on_status(user, notice_message)
  end

  def handle_user_not_found
    reset_session_and_cookies
    redirect_to root_path, alert: 'Sign in failed: User not found'
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

    if shibboleth_attributes_present?
      process_shibboleth_login
    else
      Rails.logger.error 'Shibboleth attributes not present. Cannot authenticate user.'
      redirect_to root_path, alert: 'Authentication failed: Shibboleth attributes not present.'
    end
  end

  def shibboleth_attributes_present?
    # Log the available request.env keys
    Rails.logger.error "Available request.env keys: #{request.env.keys.inspect}"

    # Optionally, log specific Shibboleth-related keys
    shibboleth_keys = request.env.keys.select { |k| k =~ /uid|mail|displayName|eppn|REMOTE_USER/i }
    shibboleth_keys.each do |key|
      Rails.logger.error "#{key}: #{request.env[key]}"
    end

    attribute_names = %w[uid eppn REMOTE_USER]
    attribute_names.any? { |attr| request.env[attr].present? || request.env["HTTP_#{attr.upcase}"].present? }
  end

  def process_shibboleth_login
    # Define the potential Shibboleth attributes for username
    attribute_names = %w[uid eppn REMOTE_USER]

    # Find the first attribute that is present in request.env and use it as the username
    username = attribute_names.map { |attr| request.env[attr] || request.env["HTTP_#{attr.upcase}"] }.compact.first

    if username.present?
      # Find the user in the database by the identified username
      user = User.find_by(username: username)

      if user
        handle_successful_login(user, 'Signed in successfully.')
      else
        handle_user_not_found
      end
    else
      # Log an error if none of the expected attributes are present
      Rails.logger.error 'Shibboleth username attribute not present in request.env.'
      redirect_to root_path, alert: 'Authentication failed: Username attribute not present.'
    end
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
