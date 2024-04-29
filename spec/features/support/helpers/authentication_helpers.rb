# frozen_string_literal: true

require 'rails_helper'

module AuthenticationHelpers
  def log_in_as_user(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword' # from the factory
    click_button 'Log in'
    validate_login_success
  end

  private

  def validate_login_success
    check_successful_sign_in
    check_no_error_messages
    user_should_be_on_conservation_records_page
  end

  def check_successful_sign_in
    expect(flash_notice).to have_content('Signed in successfully')
  end

  def check_no_error_messages
    expect(flash_alert).to_not have_content('Invalid Email or password.')
    expect(page).to_not have_content('Log in')
    expect(flash_notice).to_not have_content('You are already signed in.')
  end

  def user_should_be_on_conservation_records_page
    expect(page).to have_current_path(conservation_records_path)
    expect(page).to have_selector('h1', text: 'Conservation Records')
  end
end
