# frozen_string_literal: true

class CallbacksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:shibboleth]

  def shibboleth
    auth = request.env['omniauth.auth']
    shibboleth_attributes = {
      email: auth.info.email,
      username: auth.uid,
    }
    user = User.find_by(username: shibboleth_attributes[:username])

    if user
      user.update(email: shibboleth_attributes[:email])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Welcome, #{user.display_name}. You have successfully logged in."
    else
      redirect_to root_path, alert: 'User not found. Please contact the system administrator.'
    end
  end
end
