# frozen_string_literal: true

module SystemAuthenticationHelper
  def system_login_as(user)
    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Log in'
  end

  def system_logout
    visit root_path

    # Check if the dropdown toggle (usually a user name or icon) is visible, indicating the user is logged in
    return unless has_selector?('button.dropdown-toggle', visible: true)

    # Open the dropdown menu
    find('button.dropdown-toggle').click

    # Click the logout link inside the dropdown menu
    click_link 'Logout'
  end
end
