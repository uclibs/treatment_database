# frozen_string_literal: true

module SamlHelper
  def saml_settings
    settings = OneLogin::RubySaml::Settings.new

    configure_sp_settings(settings)
    configure_idp_settings(settings)
    configure_security_settings(settings)

    settings
  end

  def shibboleth_login_url
    target_url = shibboleth_callback_url
    shibboleth_login_url = ENV.fetch('SHIBBOLETH_LOGIN_URL', nil)
    "#{shibboleth_login_url}?target=#{CGI.escape(target_url)}"
  end

  def shibboleth_logout_url
    return_url = root_url
    shibboleth_logout_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL', nil)
    "#{shibboleth_logout_url}?target=#{CGI.escape(return_url)}"
  end

  private

  def configure_sp_settings(settings)
    settings.assertion_consumer_service_url = shibboleth_callback_url
    settings.sp_entity_id = ENV.fetch('SP_ENTITY_ID', nil)
    settings.single_logout_service_url = shibboleth_logout_url
  end

  def configure_idp_settings(settings)
    settings.idp_entity_id = ENV.fetch('IDP_ENTITY_ID', nil)
    settings.idp_sso_target_url = ENV.fetch('SHIBBOLETH_LOGIN_URL', nil)
    settings.idp_slo_target_url = ENV.fetch('SHIBBOLETH_LOGOUT_URL', nil)
    settings.idp_cert = Rails.root.join('config/idp_certificate.pem').read
    settings.name_identifier_format = 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'
  end

  def configure_security_settings(settings)
    settings.security[:authn_requests_signed] = false
    settings.security[:logout_requests_signed] = true
    settings.security[:want_assertions_signed] = true
    settings.security[:metadata_signed] = true
  end
end
