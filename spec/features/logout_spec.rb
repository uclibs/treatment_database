# frozen_string_literal: true

# spec/features/logout_spec.rb
require 'rails_helper'

RSpec.describe 'Logout button', type: :feature do
  let(:admin_user) { create(:user, role: 'admin') }

  before do
    dev_log_in_user(admin_user)
  end

  context 'in development environment' do
    it 'logs out when the Logout button is clicked' do
      with_environment('development') do
        visit root_path

        # Click on the dropdown to expose the logout options
        find('.dropdown-toggle').click

        # Check for Production Logout button
        expect(page).to have_link('Sign Out', href: logout_path)

        # Check for Dev Logout button
        expect(page).to have_link('Dev Sign Out', href: dev_logout_path)

        # Simulate clicking the logout button
        click_link 'Dev Sign Out'

        # Add your expectations for after the user logs out
        expect(page).to have_current_path(root_path)
        expect(page).to have_content('Signed out successfully')
      end
    end

    it 'logs out via Shibboleth when the button is clicked' do
      with_environment('development') do
        visit root_path

        # Click on the dropdown to expose the logout options
        find('.dropdown-toggle').click

        # Check for Dev logout button
        expect(page).to have_link('Dev Sign Out', href: dev_logout_path)

        # Check for Shibboleth logout button
        expect(page).to have_link('Sign Out', href: logout_path)

        # Simulate clicking the logout via Shibboleth button
        click_link 'Sign Out'

        # Add your expectations for after the user logs out via Shibboleth
        expect(page).to have_current_path(root_path, ignore_query: true)
        expect(page).to have_content('Signed out successfully')
      end
    end
  end

  context 'in production environment' do
    it 'logs out via standard method when the button is clicked' do
      with_environment('production') do
        visit root_path

        # Click on the dropdown to expose the logout options
        find('.dropdown-toggle').click

        # Check that the dev logout button is not present
        expect(page).not_to have_link('Dev Sign Out')

        # Check for Production logout button
        expect(page).to have_link('Sign Out', href: logout_path)

        # Standard logout
        click_link 'Sign Out'

        # Expectations after standard logout
        expect(page).to have_current_path(root_path, ignore_query: true)
        expect(page).to have_content('Signed out successfully')
      end
    end
  end
end
