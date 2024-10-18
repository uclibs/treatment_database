# frozen_string_literal: true

module AuthenticationHelpers
  def dev_log_in_user(user)
    visit dev_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Submit'
    expect(page).to have_content('Signed in successfully')
  end
end
