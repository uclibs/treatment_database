# frozen_string_literal: true

module RequestAuthenticationHelper
  def request_login_as(user)
    post dev_sessions_path, params: { email: user.email, password: user.password }
    follow_redirect! if response.redirect?
  end
end
