# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
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

  config.before(:suite) do
    Rails.application.load_tasks
    Rails.root.glob('lib/capistrano/tasks/*.rake').each { |file| load file }
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.load_seed # Ensure seeds are loaded after truncation
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each) do
    Capybara.reset_sessions!
    RSpec::Mocks.space.reset_all
    DatabaseCleaner.clean
  end

  config.fixture_path = Rails.root.join('spec/fixtures').to_s
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end
