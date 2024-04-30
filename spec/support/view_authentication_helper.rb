# frozen_string_literal: true

# This module is used to help with authentication in view tests
module ViewAuthenticationHelper
  def view_login_as(user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(true)
  end

  def view_logout
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(nil)
    allow_any_instance_of(ApplicationController).to receive(:user_signed_in?).and_return(false)
  end

  def view_stub_authorization(user)
    ability = Ability.new(user)
    allow(controller).to receive(:current_ability).and_return(ability)
    allow(view).to receive(:can?) do |action, subject|
      ability.can?(action, subject)
    end
  end
end
