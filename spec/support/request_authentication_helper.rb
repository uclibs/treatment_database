# frozen_string_literal: true

module RequestAuthenticationHelper
  def request_login_as(user)
    post dev_login_path, params: { email: user.email, password: user.password }
    follow_redirect! if response.redirect?
  end

  def request_logout
    delete dev_logout_path
  end
end
