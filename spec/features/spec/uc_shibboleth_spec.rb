# This file is copied directly from ucrate.  We will need to adjust it to fit our
# application.

# frozen_string_literal: true

require 'rails_helper'

describe 'UC account workflow', type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:password) { FactoryBot.attributes_for(:user).fetch(:password) }
  let(:locale) { 'en' }

  describe 'overridden devise password reset page' do
    context 'with a uc.edu email address' do
      email_address = 'fake.user@uc.edu'
      it 'rejects password reset for @.uc.edu user' do
        visit new_user_password_path
        fill_in('user[email]', with: email_address)
        click_on('Send me reset password instructions')
        expect(page).to have_content('You cannot reset passwords for @uc.edu accounts. Use your UC Central Login instead')
      end
    end
  end

  describe 'overridden devise password reset page' do
    it 'shows a Central Login option with shibboleth enabled' do
      AUTH_CONFIG['shibboleth_enabled'] = true
      visit new_user_password_path
      expect(page).to have_content('Reset Password has been disabled')
    end

    # we can keep the sign in link?
    it 'does not display the Shared links at the bottom' do
      visit new_user_password_path
      expect(page).not_to have_link('Sign in', href: '/users/sign_in')
      expect(page).not_to have_link('Sign up', href: '/users/sign_up')
    end
  end

  # keep- should we redirect automatically
  describe 'overridden devise sign-in page' do
    it 'shows a shibboleth login link if shibboleth is enabled' do
      AUTH_CONFIG['shibboleth_enabled'] = true
      visit new_user_session_path
      expect(page).to have_link('Central Login form', href: user_shibboleth_omniauth_authorize_path(locale:))
    end
    # do we need this for local development?
    it 'does not show a shibboleth login link if shibboleth is disabled' do
      AUTH_CONFIG['shibboleth_enabled'] = false
      visit new_user_session_path
      expect(page).not_to have_link('Central Login form', href: user_shibboleth_omniauth_authorize_path(locale:))
    end
  end

  # keep
  describe 'shibboleth login page' do
    # left this in in case we need to disable shib for development
    context 'when shibboleth is enabled' do
      before do
        AUTH_CONFIG['shibboleth_enabled'] = true
        visit login_path
      end

      it 'shows a shibboleth login link' do
        expect(page).to have_link('UC Central Login username', href: 'https://www.uc.edu/distance/Student_Orientation/One_Stop_Student_Resources/central-log-in-.html')
      end
    end
    # - need to talk with Glen about how to run (or not) shibboleth in development
    context 'when shibboleth is not enabled' do
      before do
        AUTH_CONFIG['shibboleth_enabled'] = false
        visit login_path
      end
      it 'shows the local log in page' do
        expect(page).to have_field('user[email]')
      end
    end
  end

  # keep all below
  describe 'shibboleth password management' do
    it 'hides the password change fields for shibboleth users' do
      login_as(user)
      user.provider = 'shibboleth'
      visit hyrax.edit_dashboard_profile_path(user)
      expect(page).not_to have_field('user[password]')
      expect(page).not_to have_field('user[password_confirmation]')
    end
  end

  # if we have a login page or just redirect ...?
  describe 'home page login button' do
    it 'shows the correct login link' do
      visit root_path
      expect(page).to have_link('Login', href: "#{login_path}?locale=en")
    end
  end

  # it should redirect to root page automatically after logout.
  # Do we need the cookie ?
  describe 'a user using a UC Shibboleth login' do
    it 'redirects to the UC Shibboleth logout page after logout' do
      create_cookie('login_type', 'shibboleth')
      visit('/users/sign_out')
      expect(page).to have_content("You have been logged out of the University of Cincinnati's Login Service")
    end
  end
end
