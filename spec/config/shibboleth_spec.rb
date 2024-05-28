# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shibboleth Configuration' do
  describe 'Environment Variable' do
    it 'checks for the presence of SHIBBOLETH_SSO_ENABLED' do
      expect(ENV).to have_key('SHIBBOLETH_SSO_ENABLED')
    end
  end

  shared_examples 'correctly parses shibboleth config' do |environment|
    let(:shibboleth_config) { YAML.safe_load(ERB.new(Rails.root.join('config/shibboleth.yml').read).result) }

    it "parses the ERB content correctly for #{environment}" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('SHIBBOLETH_SSO_ENABLED').and_return('true')
      expect(shibboleth_config[environment]['shibboleth_enabled']).to eq(true)
    end
  end

  describe 'Configuration File' do
    it 'loads the configuration' do
      expect(shibboleth_config).to be_a(Hash)
    end

    include_examples 'correctly parses shibboleth config', 'development'
    include_examples 'correctly parses shibboleth config', 'test'
    include_examples 'correctly parses shibboleth config', 'production'
  end

  describe 'SHIBBOLETH_ENABLED' do
    context 'when the configuration is set to true' do
      let(:shibboleth_config) do
        {
          'development' => { 'shibboleth_enabled' => 'true' },
          'test' => { 'shibboleth_enabled' => 'true' },
          'production' => { 'shibboleth_enabled' => 'true' }
        }
      end
      before do
        allow(YAML).to receive(:safe_load).and_return(shibboleth_config)
      end

      it 'matches the environment configuration' do
        load Rails.root.join('config/initializers/shibboleth.rb')
        expect(SHIBBOLETH_ENABLED).to eq('true')
      end
    end

    context 'when the configuration is set to false' do
      let(:shibboleth_config) do
        {
          'development' => { 'shibboleth_enabled' => 'false' },
          'test' => { 'shibboleth_enabled' => 'false' },
          'production' => { 'shibboleth_enabled' => 'false' }
        }
      end
      before do
        allow(YAML).to receive(:safe_load).and_return(shibboleth_config)
      end

      it 'matches the environment configuration' do
        load Rails.root.join('config/initializers/shibboleth.rb')
        expect(SHIBBOLETH_ENABLED).to eq('false')
      end
    end
  end
end
