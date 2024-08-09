# frozen_string_literal: true

require 'rails_helper'

require 'capybara'

Capybara.register_driver :selenium_chrome_headless_sandboxless do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--no-sandbox'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end
Capybara.default_driver = :rack_test # This is a faster driver
Capybara.javascript_driver = :selenium_chrome_headless_sandboxless

RSpec.feature 'Navbar', type: :feature do
  let(:user) { create(:user, role: 'admin') }

  before do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Log in'
    expect(page).to have_content('Signed in successfully')
    expect(page).to have_content('Conservation Records')
  end

  scenario 'displays links when the screen is wide', js: true do
    # Simulate a large screen
    page.driver.browser.manage.window.resize_to(1200, 800)

    expect(page).to have_link('Conservation Records')
    expect(page).to have_link('Users')
  end

  scenario 'displays the hamburger menu on small screens', js: true do
    # Simulate a small screen
    page.driver.browser.manage.window.resize_to(320, 480)

    # Check for the hamburger button
    expect(page).to have_css('.navbar-toggler')
    expect(page).not_to have_link('Conservation Records')

    # Open the hamburger menu
    find('.navbar-toggler').click
    expect(page).to have_content('Conservation Records')

    # Now check for the link presence
    expect(page).to have_link('Conservation Records')
    expect(page).to have_link('Users')
  end
end
