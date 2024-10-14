# frozen_string_literal: true

require 'rails_helper'

# frozen_string_literal: true

RSpec.describe 'Navigation Menu', type: :system do
  include Devise::Test::IntegrationHelpers

  context 'when the user is logged out' do
    it 'displays the log in button on large screens' do
      resize_window_to(1024, 768)
      visit root_path

      # Ensure the navbar is visible
      expect(page).to have_css('.navbar', visible: true)

      # Ensure the 'Log in' button is visible on large screens
      expect(page).to have_css('a.btn.btn-secondary', text: 'Log in', visible: true)

      # Ensure the navbar-toggler is not visible
      expect(page).to have_no_css('.navbar-toggler', visible: true)
    end

    it 'displays the log in button on small screens' do
      resize_window_to(375, 667)
      visit root_path

      # Ensure the 'Log in' button is visible on small screens
      expect(page).to have_css('a.btn.btn-secondary', text: 'Log in', visible: true)

      # Ensure the navbar-toggler is not visible since it's not used for logged-out users
      expect(page).to have_no_css('.navbar-toggler', visible: true)
    end
  end

  context 'when the user is logged in' do
    let(:user) { create(:user) }

    it 'displays the full menu on large screens' do
      sign_in user
      visit root_path
      resize_window_to(1024, 768)

      # Ensure the navbar is expanded and visible
      expect(page).to have_css('.navbar', visible: true)
      expect(page).to have_css('.navbar-collapse.collapse', visible: true)

      # Ensure user-specific links are visible when logged in
      expect(page).to have_css('.navbar-collapse .nav-link', text: 'Conservation Records', visible: true)

      # Ensure the navbar-toggler is not visible on large screens
      expect(page).to have_no_css('.navbar-toggler', visible: true)
    end

    it 'displays the hamburger menu on small screens' do
      sign_in user
      visit root_path
      resize_window_to(375, 667)

      # Ensure the navbar-toggler (hamburger menu) is visible
      expect(page).to have_css('.navbar-toggler', visible: true)

      # Ensure the navbar is collapsed by default
      expect(page).to have_css('.navbar-collapse.collapse', visible: false)

      # Click the navbar-toggler to expand the menu
      find('.navbar-toggler').click

      # Ensure the navbar expands after toggling
      expect(page).to have_css('.navbar-collapse.collapse', visible: true)

      # Ensure user-specific links are visible after expanding
      expect(page).to have_css('.navbar-collapse .nav-link', text: 'Conservation Records', visible: true)
    end
  end
end
