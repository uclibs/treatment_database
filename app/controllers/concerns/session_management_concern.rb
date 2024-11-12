# frozen_string_literal: true

module SessionManagementConcern
  extend ActiveSupport::Concern

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

    session[:last_seen] < Time.current - timeout_duration
  end

  def expire_session
    reset_session
    redirect_to root_path, alert: 'Your session has expired. Please sign in again.'
  end

  def reset_session_and_cookies
    reset_session
    preserve_shibboleth_cookies
  end

  def preserve_shibboleth_cookies
    shibboleth_cookies = %w[_shibsession_ _shibstate_]

    # Iterate over each known cookie key and delete if it doesn’t start with Shibboleth prefixes
    cookies.to_hash.each_key do |key|
      cookies.delete(key) unless shibboleth_cookies.any? { |shib_cookie| key.start_with?(shib_cookie) }
    end
  end


end
