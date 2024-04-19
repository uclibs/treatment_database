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
  end

  def check_successful_sign_in
    expect(page).to have_content('Signed in successfully')
    expect(page).to have_content('Conservation Records')
  end

  def check_no_error_messages
    expect(page).to_not have_content('Invalid Email or password.')
    expect(page).to_not have_content('Log in')
    expect(page).to_not have_content('You are already signed in.')
  end
end
