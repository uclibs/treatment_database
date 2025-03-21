# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dev Login Page', skip: 'Temporarily skipping due to Chrome updates before deploy', type: :feature do
  let(:active_user) { create(:user, account_active: true) }
  let(:inactive_user) { create(:user, account_active: false) }

  context 'when logging in with valid credentials' do
    it 'allows active users to log in and redirects to conservation records page' do
      with_environment('development') do
        visit root_path
        click_button 'Dev Sign In'
        fill_in 'Username', with: active_user.username
        click_button 'Submit'
        expect(page).to have_content('Signed in successfully')
        expect(page).to have_current_path(conservation_records_path)
      end
    end
  end

  context 'when using invalid credentials' do
    it 'shows an error message for incorrect username' do
      with_environment('development') do
        visit root_path
        click_button 'Dev Sign In'
        fill_in 'Username', with: 'wrong_username'
        click_button 'Submit'
        expect(page).to have_content('Invalid username')
        expect(page).to have_current_path(dev_login_path) # Ensure it stays on the login page
      end
    end
  end

  context 'when account is inactive' do
    it 'prevents login and shows an inactive account message' do
      with_environment('development') do
        visit root_path
        click_button 'Dev Sign In'
        fill_in 'Username', with: inactive_user.username
        click_button 'Submit'
        expect(page).to have_content('Your account is not active.')
        expect(page).to have_current_path(root_path) # Redirected to root because the account is inactive
      end
    end
  end
end
