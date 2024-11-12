# frozen_string_literal: true

module AuthenticationConcern
  extend ActiveSupport::Concern
  include SessionManagementConcern
  include ShibbolethAuthenticationConcern
  include UserConcern

  private

  def authenticate_user!
    return if user_signed_in?

    if shibboleth_attributes_present?
      process_shibboleth_login
    else
      Rails.logger.error 'Shibboleth attributes not present. Cannot authenticate user.'
      redirect_to root_path, alert: 'Authentication failed: Shibboleth attributes not present.'
    end
  end
end

