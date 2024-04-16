# frozen_string_literal: true

# This file is part of the RSpec configuration when 'rails generate rspec:install' is run.
# It sets up the test environment for RSpec.

require 'dotenv'
Dotenv.load('.env.test') # Make sure this is the first thing after requiring dotenv

# Set the environment to test if it is not already set
Rails.env = 'test' if Rails.env.development?

# Load Rails and core components
require File.expand_path('../config/environment', __dir__)

# Abort if the environment is accidentally set to production
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Requires the standard RSpec helpers.
require 'spec_helper'
require 'rspec/rails'

# Additional requires for test-specific functionalities.
require 'capybara/rspec'
require 'factory_bot_rails'
require 'paper_trail/frameworks/rspec'

# Load all feature-specific support files.
Dir[Rails.root.join('spec/features/support/**/*.rb')].each { |f| require f }

# Configure Capybara to use Selenium with headless Chrome for all tests
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.args << '--headless'
  options.args << '--disable-gpu' # GPU acceleration isn't useful for headless testing.
  options.args << '--no-sandbox'  # Recommended for CI environments, remove if causes issues locally.
  options.add_argument('--disable-dev-shm-usage') # avoid issues in confined environments like Docker containers

  options.add_preference(:loggingPrefs, { browser: 'ALL' })
  options.add_preference(:download, {
                           prompt_for_download: false, # Do not prompt for download
                           default_directory: '/dev/null' # Discard all downloaded files
                         })
  options.add_preference(:plugins, {
                           always_open_pdf_externally: false # Do not open PDFs externally
                         })

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

# Set Capybara's default and JavaScript driver to Selenium with headless Chrome
Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless

# Ensures the database schema is up-to-date before running any tests
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Configure RSpec to manage fixtures location.
  config.fixture_path = Rails.root.join('spec/fixtures')

  # Use transactional fixtures to maintain a clean state between tests.
  config.use_transactional_fixtures = true

  # Automatically infer an example group's spec type from the file location.
  config.infer_spec_type_from_file_location!

  # Filter out framework and any third-party gems from backtraces to minimize noise.
  config.filter_rails_from_backtrace!
  # Optionally filter additional gems with config.filter_gems_from_backtrace("gem name")

  # Include FactoryBot syntax to simplify calls to factories.
  config.include FactoryBot::Syntax::Methods

  # Load seeds before running tests to ensure that test environment reflects production seed data.
  Rails.application.load_seed

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.include AuthenticationHelpers, type: :feature
  config.include PDFDownloadHelper, type: :feature
end
