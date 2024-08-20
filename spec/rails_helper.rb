# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'factory_bot'
require 'paper_trail/frameworks/rspec'
require 'capistrano-spec'

# Add additional requires below this line. Rails is not loaded until this point!

# Auto-require all Ruby files in the spec/support directory.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include_context 'rake', type: :task
  config.include_context 'job', type: :job

  config.include DownloadLinkHelper, type: :feature
  config.include AxeHelper, type: :system
  config.include WindowResizer, type: :system
  config.include WindowResizer, type: :feature
  config.include ShowMeTheCookies, type: :feature
  config.include ViewAuthenticationHelper, type: :view
  config.include RequestAuthenticationHelper, type: :request
  config.include ControllerAuthenticationHelper, type: :controller

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    Rails.application.load_tasks
    Rails.root.glob('lib/capistrano/tasks/*.rake').each { |file| load file }
  end

  config.before(:each, type: :feature) do
    Capybara.reset_sessions!
    # Only resize the window if the test is using a browser-based driver
    set_default_window_size if page.driver.browser.respond_to?(:manage)
  end

  config.before(:each, type: :system) do |_example|
    driven_by :selenium_chrome_headless_sandboxless
    set_default_window_size
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join('spec/fixtures').to_s

  config.use_transactional_fixtures = false

  config.before do |example|
    DatabaseCleaner.strategy = if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
                                 :truncation
                               else
                                 :transaction
                               end

    DatabaseCleaner.start
    Rails.application.load_seed
  end

  config.after do
    Capybara.reset_sessions!
    RSpec::Mocks.space.reset_all
    DatabaseCleaner.clean
  end

  config.fixture_path = Rails.root.join('spec/fixtures').to_s
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
