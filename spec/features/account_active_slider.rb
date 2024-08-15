# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Account Active Slider', type: :feature, js: true do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:standard_user) { create(:user, role: 'standard', account_active: false) }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms', department: 2) }
  let(:vocabulary) { create(:controlled_vocabulary) }

  scenario 'user toggles the account active slider and label changes' do
    log_in_user(admin_user)
    visit edit_user_path(standard_user)

    # Verify initial state
    expect(find('#accountActiveSwitch')).not_to be_checked
    expect(find('#accountActiveLabel')).to have_content('Account Inactive')

    # Toggle the switch (simulate clicking the slider)
    find('#accountActiveSwitch').set(true)

    # Verify label update
    expect(find('#accountActiveLabel')).to have_content('Account Active')

    # Toggle back
    find('#accountActiveSwitch').set(false)

    # Verify label update again
    expect(find('#accountActiveLabel')).to have_content('Account Inactive')
  end

  # Login
  def log_in_user(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
  end
end
