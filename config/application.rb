# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'dotenv-rails'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

Dotenv::Rails.load

module TreatmentDatabase
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.active_job.queue_adapter = :inline
    config.active_record.yaml_column_permitted_classes = [ActiveSupport::TimeWithZone, Time, ActiveSupport::TimeZone]
    config.assets.enabled = false # Disable the asset pipeline and Sprockets
    config.assets.compile = false # Disable fallback to Sprockets if a precompiled asset is missed
  end
end
