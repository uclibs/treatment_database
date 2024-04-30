# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shibboleth Login', type: :feature, js: false do
  context 'when in the production environment' do
    it 'redirects to the correct Shibboleth login URL' do
      with_environment('production') do
        # Temporarily disable static file serving for this test
        Rails.application.config.public_file_server.enabled = false

        visit root_path
        click_link 'Log in'

        expect(page).to have_current_path(%r{target=.*shibboleth/callback})
      end
    end
  end
end
