# frozen_string_literal: true

class TestShibbolethController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[logout]
  skip_before_action :check_user_active, only: %i[logout]
  def logout
    # Simulate Shibboleth logout processing
    flash[:notice] = 'Test Shibboleth logout simulated.'
    redirect_to root_path
  end
end
