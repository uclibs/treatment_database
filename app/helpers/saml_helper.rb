# frozen_string_literal: true

module SamlHelper
  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    # SP (Treatment Database) settings
    settings.assertion_consumer_service_url = shibboleth_callback_url
    settings.sp_entity_id = ENV.fetch('SP_ENTITY_ID', nil)
    settings.single_logout_service_url = shibboleth_logout_url

    # IdP (Shibboleth) settings from metadata
    settings.idp_entity_id = ENV.fetch('IDP_ENTITY_ID', nil)
    settings.idp_sso_target_url = ENV.fetch('SHIBBOLETH_LOGIN_URL', nil)
    settings.idp_slo_target_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL', nil)
    settings.idp_cert = File.read(Rails.root.join('/idp_certificate.pem'))
    settings.name_identifier_format = 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'

    # Security settings
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = true
    settings.security[:want_assertions_signed] = true
    settings.security[:metadata_signed] = true

    settings
  end
end
