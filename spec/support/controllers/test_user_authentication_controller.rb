# frozen_string_literal: true

class TestUserAuthenticationController < ApplicationController
  include UserAuthenticationConcern

  def index
    render plain: 'Protected content'
  end

  def admin_area
    if admin?
      render plain: 'Admin content'
    else
      render plain: 'Access denied', status: :forbidden
    end
  end
end
