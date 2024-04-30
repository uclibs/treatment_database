# frozen_string_literal: true

class FrontController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :check_user_active, only: [:index]
  def index; end
end
