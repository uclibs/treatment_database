# frozen_string_literal: true

module AuthenticationConcern
  extend ActiveSupport::Concern
  include SessionManagementConcern
  include UserAuthenticationConcern

end

