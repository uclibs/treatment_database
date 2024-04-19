# frozen_string_literal: true

# authentication_helpers.rb contains a set of helper methods designed
# to assist in managing user authentication across various RSpec tests.
# These methods facilitate common authentication tasks such as logging
# users in and out, which are essential for testing different parts
# of the application with various access levels. Additionally, this file
# includes methods to verify that users can only access areas of the
# application appropriate for their permission levels, ensuring robust s
# ecurity testing. By centralizing these methods here, we reduce code
# duplication and increase the maintainability of our tests. This setup
# allows for easy updates and extensions as the authentication requirements
# of the application evolve.

require 'rails_helper'

module AuthenticationHelpers
end
