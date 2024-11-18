# app/controllers/test_authentication_controller.rb

class TestAuthenticationController < ApplicationController
  include UserAuthenticationConcern

  # Actions to test each method
  def index
    # Action to test authenticate_user!
    authenticate_user!
    render plain: 'Index Page'
  end

  def show
    # Action to test check_user_active
    authenticate_user!
    check_user_active
    render plain: 'Show Page'
  end

  def admin_dashboard
    # Action to test admin?
    authenticate_user!
    if admin?
      render plain: 'Admin Dashboard'
    else
      redirect_to root_path, alert: 'Access denied.'
    end
  end
end
