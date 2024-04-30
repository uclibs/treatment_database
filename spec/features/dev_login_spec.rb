# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dev Login Page', type: :feature do
  context 'when in development' do
    it 'displays both the Log in button and the Shibboleth login button' do
      with_environment('development') do
        visit new_dev_session_path

        # Check for the presence of the Log in button
        expect(page).to have_selector("input[type='submit'][name='commit'][value='Log in'][data-disable-with='Log in']")

        # Check for the presence of the Shibboleth login link
        expect(page).to have_link('Log in with Shibboleth Instead', href: '/sessions/new')
      end
    end

    it 'displays the Shibboleth button with correct styling' do
      with_environment('development') do
        visit new_dev_session_path

        shibboleth_button = find_link('Log in with Shibboleth Instead')
        expect(shibboleth_button[:class]).to include('btn', 'btn-secondary')
      end
    end
  end
end
