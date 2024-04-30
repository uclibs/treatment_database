# frozen_string_literal: true

module RequestAuthenticationHelper
  def request_login_as(user)
    post sessions_path, params: { email: user.email, password: user.password }
    follow_redirect! if response.redirect?
  end

  def request_logout
    delete logout_path
  end

  def request_stub_authorization(user)
    ability = Ability.new(user)
    allow_any_instance_of(ApplicationController).to receive(:current_ability).and_return(ability)
  end
end
