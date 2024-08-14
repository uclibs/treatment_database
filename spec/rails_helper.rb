# frozen_string_literal: true

Rails.env = 'test'

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'factory_bot'
require 'rspec/rails'
require 'paper_trail/frameworks/rspec'
require 'capistrano-spec'

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Add additional requires below this line. Rails is not loaded until this point!

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
  config.include_context 'rake', type: :task
  config.include_context 'job', type: :job
  config.include DownloadLinkHelper, type: :feature

  config.before(:suite) do
    # Ensure the database is clean and fresh
    DatabaseCleaner.clean_with(:truncation)

    # Load all Capistrano tasks
    Rails.application.load_tasks
    Rails.root.glob('lib/capistrano/tasks/*.rake').each { |file| load file }
  end

  config.before(:each, type: :feature) do
    Capybara.reset_sessions!
  end

  config.after(:each, type: :feature) do
    Capybara.reset_sessions!
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join('spec/fixtures').to_s

  config.use_transactional_fixtures = false

  config.before do |example|
    if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end

    # Reload seeds before each test to ensure the seed data is available
    Rails.application.load_seed
  end

  config.after do
    DatabaseCleaner.clean
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include FactoryBot::Syntax::Methods

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request
end
