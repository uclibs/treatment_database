# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

RSpec.configure do |_config|
  Capybara.register_driver :selenium_chrome_headless_sandboxless do |app|
    browser_options = Selenium::WebDriver::Chrome::Options.new
    browser_options.args << '--headless'
    browser_options.args << '--disable-gpu'
    browser_options.args << '--no-sandbox'
    browser_options.prefs['safebrowsing.enabled'] = true

    # Create the driver with the specified options
    driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)

    # Set the window size to a typical desktop resolution
    driver.browser.manage.window.resize_to(1280, 1024)

    driver
  end

  Capybara.default_driver = :rack_test
  Capybara.javascript_driver = :selenium_chrome_headless_sandboxless
end
