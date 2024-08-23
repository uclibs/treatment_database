# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Account Active Slider', type: :feature, js: true do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:standard_user) { create(:user, role: 'standard', account_active: false) }

  context 'when admin toggles the account active slider' do
    before do
      log_in_user(admin_user)
      visit edit_user_path(standard_user)
    end

    it 'displays the correct initial state' do
      expect(find('#accountActiveSwitch')).not_to be_checked
      expect(find('#accountActiveLabel')).to have_content('Account Inactive')
    end

    it 'updates the label to Account Active when toggled' do
      expect(find('#accountActiveLabel')).to have_content('Account Inactive')

      find('#accountActiveSwitch').set(true)
      expect(find('#accountActiveLabel')).to have_content('Account Active')

      find('#accountActiveSwitch').set(false)
      expect(find('#accountActiveLabel')).to have_content('Account Inactive')
    end
  end

  # Login helper
  def log_in_user(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapass'
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
  end
end
