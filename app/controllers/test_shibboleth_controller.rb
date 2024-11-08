# frozen_string_literal: true

# # frozen_string_literal: true
#
# # This controller is used in the test environment to simulate Shibboleth logout processing.
# # It is not used in the production environment, but is required for testing purposes.
#
# class TestShibbolethController < ApplicationController
#   skip_before_action :authenticate_user!, only: %i[logout]
#   skip_before_action :check_user_active, only: %i[logout]
#   def logout
#     # Simulate Shibboleth logout processing
#     flash[:notice] = 'Test Shibboleth logout simulated.'
#     redirect_to root_path
#   end
# end
