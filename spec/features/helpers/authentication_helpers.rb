module AuthenticationHelpers
  def it_logs_out_the_user_successfully(username)
    # Clicking the user's name to open dropdown menu
    find('button', text: username).click

    begin
      # Attempt to find the dropdown menu and click on the logout link
      within('.dropdown-menu') do
        click_link 'Logout'
      end
    rescue Capybara::ElementNotFound
      # Raise a more descriptive error if the dropdown menu is not found
      raise "Unable to locate the dropdown-menu after attempting to click the user's name. It may be Bootstrap isn't loading correctly."
    end

    expect(page).to_not have_content(username)
    expect(page).to have_content('Sign In')
  end
end
