# frozen_string_literal: true

class TestShibbolethController < ApplicationController
  include ShibbolethAuthenticationConcern

  skip_before_action :authenticate_user!
  skip_before_action :check_user_active
  skip_before_action :validate_session_timeout
  def login
    process_shibboleth_login
  end
end
