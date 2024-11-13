# frozen_string_literal: true

module ControllerAuthenticationHelper
  def controller_login_as(user)
    allow(controller).to receive(:current_user).and_return(user)
    session[:last_seen] = Time.current
    controller.instance_variable_set(:@current_user, user)
  end

  def controller_logout
    allow(controller).to receive(:current_user).and_return(nil)
  end

  def controller_stub_authorization(user)
    ability = Ability.new(user)
    allow(controller).to receive(:current_ability).and_return(ability)
  end
end
