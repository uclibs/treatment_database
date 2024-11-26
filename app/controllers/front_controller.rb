# frozen_string_literal: true

class FrontController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :check_user_active, only: [:index]
  def index
    return unless params[:logged_out] == 'true'

    flash.now[:notice] = 'You have successfully signed out.'
  end
end
