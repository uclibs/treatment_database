# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account Active Slider', skip: 'Temporarily skipping due to Chrome updates before deploy', type: :feature, js: true do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:inactive_user) { create(:user, role: 'standard', account_active: false) }
  let(:active_user) { create(:user, role: 'standard', account_active: true) }

  before do
    dev_log_in_user(admin_user)
  end

  context 'when editing a user' do
    before do
      visit edit_admin_user_path(inactive_user)
      expect(page).to have_selector('h1', text: 'Edit User', wait: 5)
    end

    it 'toggles and saves the state as active' do
      expect(find('#accountActiveSwitch')).not_to be_checked
      expect(find('#accountActiveLabel')).to have_content('Account Inactive')

      # Toggle to active
      find('#accountActiveSwitch').set(true)
      click_button 'Update User'
      # Ensure the flash message is displayed
      expect(page).to have_content('Profile updated successfully.')

      # Check if the user state is saved as active
      expect(inactive_user.reload.account_active).to be true
    end

    it 'toggles and saves the state as inactive' do
      # Toggle to active first
      find('#accountActiveSwitch').set(true)
      click_button 'Update User'

      # Ensure the flash message is displayed
      expect(page).to have_content('Profile updated successfully.')

      # Ensure the user is now active
      expect(inactive_user.reload.account_active).to be true

      # Revisit the page and toggle back to inactive
      visit edit_admin_user_path(inactive_user)
      find('#accountActiveSwitch').set(false)
      click_button 'Update User'
      # Ensure the flash message is displayed
      expect(page).to have_content('Profile updated successfully.')
      # Check if the user state is saved as inactive
      expect(inactive_user.reload.account_active).to be false
    end
  end

  context 'when creating a new user' do
    before do
      visit new_admin_user_path
      expect(page).to have_selector('h1', text: 'New User', wait: 5)
    end

    it 'toggles and saves the state as inactive' do
      expect(find('#accountActiveSwitch')).to be_checked
      expect(find('#accountActiveLabel')).to have_content('Account Active')

      # Toggle to inactive
      find('#accountActiveSwitch').set(false)
      expect(find('#accountActiveLabel')).to have_content('Account Inactive')

      # Fill in required fields
      fill_in 'Display Name', with: 'Test User'
      fill_in 'Username', with: 'testuser'

      click_button 'Create User'
      expect(page).to have_content('User created successfully.')

      created_user = User.last.reload
      expect(created_user.account_active).to be false
    end
  end
end
