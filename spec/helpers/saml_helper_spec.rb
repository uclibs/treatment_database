# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SamlHelper, type: :helper do
  describe '#saml_settings' do
    before do
      allow(ENV).to receive(:fetch).with('SP_ENTITY_ID', nil).and_return('https://libappstest.libraries.uc.edu/treatment_database/shibboleth')
      allow(ENV).to receive(:fetch).with('IDP_ENTITY_ID', nil).and_return('https://idp.example.com/shibboleth')
      allow(ENV).to receive(:fetch).with('SHIBBOLETH_LOGIN_URL', nil).and_return('https://idp.example.com/sso')
      allow(ENV).to receive(:fetch).with('SHIBBOLETH_LOGOUT_URL', nil).and_return('https://idp.example.com/slo')
    end

    it 'sets the SP entity ID' do
      expect(helper.saml_settings.sp_entity_id).to eq('https://libappstest.libraries.uc.edu/treatment_database/shibboleth')
    end

    it 'sets the assertion consumer service URL' do
      expect(helper.saml_settings.assertion_consumer_service_url).to eq(shibboleth_callback_url)
    end

    it 'sets the IdP entity ID' do
      expect(helper.saml_settings.idp_entity_id).to eq('https://idp.example.com/shibboleth')
    end

    it 'sets the IdP SSO target URL' do
      expect(helper.saml_settings.idp_sso_target_url).to eq('https://idp.example.com/sso')
    end

    it 'sets the IdP SLO target URL' do
      expect(helper.saml_settings.idp_slo_target_url).to eq('https://idp.example.com/slo')
    end

    it 'loads the IdP certificate from the file' do
      certificate_path = Rails.root.join('config/idp_certificate.pem')
      expect(helper.saml_settings.idp_cert).to eq(certificate_path.read)
    end

    it 'sets the name identifier format' do
      expect(helper.saml_settings.name_identifier_format).to eq('urn:oasis:names:tc:SAML:2.0:nameid-format:persistent')
    end

    it 'configures security settings correctly' do
      security_settings = helper.saml_settings.security
      expect(security_settings[:authn_requests_signed]).to eq(false)
      expect(security_settings[:logout_requests_signed]).to eq(true)
      expect(security_settings[:want_assertions_signed]).to eq(true)
      expect(security_settings[:metadata_signed]).to eq(true)
    end
  end

  describe '#shibboleth_login_url' do
    before do
      allow(ENV).to receive(:fetch).with('SHIBBOLETH_LOGIN_URL', nil).and_return('https://idp.example.com/sso')
      allow(helper).to receive(:shibboleth_callback_url).and_return('https://libappstest.libraries.uc.edu/treatment_database/auth/shibboleth/callback')
    end

    it 'generates the correct login URL with target parameter' do
      expected_url = 'https://idp.example.com/sso?target=https%3A%2F%2Flibappstest.libraries.uc.edu%2Ftreatment_database%2Fauth%2Fshibboleth%2Fcallback'
      expect(helper.shibboleth_login_url).to eq(expected_url)
    end
  end

  describe '#shibboleth_logout_url' do
    before do
      allow(ENV).to receive(:fetch).with('SHIBBOLETH_LOGOUT_URL', nil).and_return('https://idp.example.com/slo')
      allow(helper).to receive(:root_url).and_return('https://libappstest.libraries.uc.edu/')
    end

    it 'generates the correct logout URL with target parameter' do
      expected_url = 'https://idp.example.com/slo?target=https%3A%2F%2Flibappstest.libraries.uc.edu%2F'
      expect(helper.shibboleth_logout_url).to eq(expected_url)
    end
  end
end
