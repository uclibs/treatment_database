# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'
require 'selenium/webdriver'

# Set the Capybara server to Puma and suppress server output for cleaner test logs
Capybara.server = :puma, { Silent: true }

# Register a custom driver for headless Chrome without sandbox
Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless' # Run in headless mode
  browser_options.args << '--disable-gpu' # Disable GPU acceleration
  browser_options.args << '--window-size=1920,1080' # Consistent viewport size

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end

# Set the default and JavaScript drivers
Capybara.default_driver = :rack_test # Fastest for non-JS tests
Capybara.javascript_driver = :selenium_chrome_headless

# Increase the default wait time to handle asynchronous JavaScript behavior
Capybara.default_max_wait_time = 5 # Increase if needed for slow-loading elements

