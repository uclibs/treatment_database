# frozen_string_literal: true

require 'rails_helper'

module AuthenticationHelpers
  def log_in_as_user(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword' # from the factory
    click_button 'Log in'

    aggregate_failures "checking login and dashboard access" do
      expect(page).to have_content('Signed in successfully')
      expect(page).to have_content('Conservation Records')
      expect(page).to_not have_content('Invalid Email or password.')
      expect(page).to_not have_content('Log in')
      expect(page).to_not have_content('You are already signed in.')
    end
  end
end
