# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create destroy]

  def new
    redirect_to '/auth/shibboleth'
  end

  def create
    # This action is typically not used directly when using Shibboleth.
    # Users are redirected to the IdP for authentication and then back to the callback.
  end

  def destroy
    session[:user_id] = nil
    @current_user = nil
    redirect_to root_path, notice: 'Logged out successfully.'
  end
end
