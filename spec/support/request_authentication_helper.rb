# frozen_string_literal: true

module RequestAuthenticationHelper
  def request_login_as(user, target: nil)
    post dev_login_path, params: { username: user.username, target: target }
    follow_redirect! if response.redirect?
  end

  def request_logout
    delete dev_logout_path
  end
end
