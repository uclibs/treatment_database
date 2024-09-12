# frozen_string_literal: true

class CallbacksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:shibboleth]
  skip_before_action :check_user_active, only: [:shibboleth]
  def shibboleth
    # This is a placeholder for the Shibboleth callback.
    render plain: 'Shibboleth callback received'

    # Possible implementation of Shibboleth callback:
    # shib_attributes = request.env['Shib-Attributes']
    # email = shib_attributes[:email]
    # username = shib_attributes[:username]
    #
    # user = User.find(email: email) do |user|
    #   user.username = username
    #   # Assign other user attributes as needed
    # end
    #
    # session[:user_id] = user.id
    # redirect_to root_path
  end
end
