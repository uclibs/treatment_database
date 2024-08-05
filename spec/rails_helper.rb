# frozen_string_literal: true

Rails.env = 'test'

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'factory_bot'
require 'paper_trail/frameworks/rspec'
require 'capistrano-spec'

# Auto-require all Ruby files in the spec/support directory.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include_context 'rake', type: :task
  config.include_context 'job', type: :job

  # Disable transactional fixtures, as we're using DatabaseCleaner
  config.use_transactional_fixtures = false

  config.before do |example|
    if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  # Load database seeds once for the entire test suite
  Rails.application.load_seed

  # Clean the database using truncation before the entire test suite
  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end

    # Clean the database before running tests
    DatabaseCleaner.clean_with(:truncation)

    # Load Rake tasks and custom tasks if needed
    Rails.application.load_tasks
    Rails.root.glob('lib/capistrano/tasks/*.rake').each { |file| load file }

    # Load database seeds
    Rails.application.load_seed
  end

  config.before do |example|
    if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  # Use truncation for JS-enabled feature tests
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  # Use truncation for system tests, which typically use an external browser
  config.before(:each, type: :system, js: true) do
    driven_by(:selenium_chrome_headless)
    DatabaseCleaner.strategy = :truncation
  end

  # Custom strategy for versioning specs
  config.before(:each, versioning: true) do
    # Enable versioning for specific models as needed
    PaperTrail.request.enable_model(User)
  end

  # Because of seed data issues, use truncation for controller tests
  config.before(:each, type: :controller) do
    DatabaseCleaner.strategy = :truncation
  end

  # Append after to ensure cleaning occurs after Capybara's cleanup
  config.append_after(:each) do
    # Reset sessions and mocks after each test
    Capybara.reset_sessions!
    RSpec::Mocks.space.reset_all
    DatabaseCleaner.clean
  end

  config.fixture_path = Rails.root.join('spec/fixtures').to_s
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end
