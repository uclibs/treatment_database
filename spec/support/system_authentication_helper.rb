# frozen_string_literal: true

module SystemAuthenticationHelper
  def system_login_as(user)
    visit dev_login_path
    fill_in 'Username', with: user.username
    click_button 'Submit'
    expect(page).to have_css('.alert', text: 'Signed in successfully. (Development)')
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
