# frozen_string_literal: true

module AuthenticationHelpers
  # Log the user in in a feature test
  def dev_log_in_user(user)
    visit dev_login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Submit'
    expect(page).to have_content('Signed in successfully')
  end

  # Simulate logging in the user via Shibboleth
  def simulate_shibboleth_attributes
    request.env['uid'] = 'testuser'
  end
end
