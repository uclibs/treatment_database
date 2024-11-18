# app/controllers/concerns/shibboleth_authentication.rb
module ShibbolethAuthenticationConcern
  extend ActiveSupport::Concern

  private

  def process_shibboleth_login
    if shibboleth_attributes_present?
      username = extract_username_from_shibboleth

      if username && (user = find_user_by_username(username))
        successful_login(user)
      else
        handle_user_not_found(username)
      end
    else
      handle_missing_shibboleth_attributes
    end
  end

  def shibboleth_attributes_present?
    request.headers['X-Shib-User'].present?
  end

  def extract_username_from_shibboleth
    full_username = request.headers['X-Shib-User']
    match = full_username.match(/^([^@]+)/)
    match[1] if match
  end

  def find_user_by_username(username)
    User.find_by(username: username)
  end

  def successful_login(user)
    handle_successful_login(user)
    redirect_to params[:target] || conservation_records_path, notice: "Welcome back, #{user.display_name}"
  end

  def handle_successful_login(user)
    reset_session_and_cookies
    session[:user_id] = user.id
    session[:last_seen] = Time.current
    Rails.logger.error "User #{user.username} logged in successfully."
  end

  def handle_user_not_found(username)
    Rails.logger.error "User with username #{username} not found."
    redirect_to root_path, alert: 'Sign in failed: User not found.'
  end

  def handle_missing_shibboleth_attributes
    Rails.logger.error 'Shibboleth attributes not present. Cannot authenticate user.'
    redirect_to root_path, alert: 'Authentication failed: Shibboleth attributes not present.'
  end
end
