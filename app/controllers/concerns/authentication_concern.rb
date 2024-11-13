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

      Rails.logger.error 'request.env attributes are:'
      if request.env[attr].is_a?(Enumerable)
        request.env[attr].each do |attribute|
          Rails.logger.error attribute
        end
      else
        Rails.logger.error "No attributes found in request.env[#{attr}] or it is not iterable."
      end

      Rails.logger.error 'request.header items are:'
      if request.headers.is_a?(Enumerable)
        request.headers.each do |header_item|
          Rails.logger.error header_item
        end
      else
        Rails.logger.error "No attributes found in request.headers or it is not iterable."
      end
      redirect_to root_path, alert: 'Authentication failed: Shibboleth attributes not present.'
    end
  end
end

