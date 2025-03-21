# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation Menu Accessibility', type: :system do
  context 'when the user is logged out' do
    it 'has no major accessibility violations on the navigation menu' do
      system_logout
      visit root_path
      check_accessibility_within('.navbar')
    end

    it 'allows the user to click Dev Sign In' do
      with_environment('development') do
        resize_window_to(768, 1024)
        system_logout
        visit root_path

        # Ensure the 'Dev Sign in' button is visible (in the testing environment)
        expect(page).to have_button('Dev Sign In', class: 'btn btn-secondary', visible: true)

        click_button 'Dev Sign In'

        expect(page).to have_current_path(dev_login_path)
      end
    end
  end

  context 'when the user is logged in' do
    let(:user) { create(:user) }

    it 'has no major accessibility violations on the navigation menu' do
      system_login_as user
      visit root_path
      check_accessibility_within('.navbar')
    end

    it 'is keyboard accessible with the hamburger menu' do
      resize_window_to(768, 1024)
      system_login_as user

      # Ensure the hamburger menu is initially collapsed
      expect(page).not_to have_css('.navbar-collapse', visible: true)

      # Send 'enter' key to the navbar-toggler (hamburger icon)
      find('.navbar-toggler').send_keys(:enter)

      # Ensure the navbar expands after toggling
      expect(page).to have_css('.navbar-collapse', visible: true)
    end
  end
end
