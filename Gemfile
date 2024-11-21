# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.3'

# Load environment variables from .env
gem 'dotenv-rails' # Loads environment variables from .env

# Core Rails gems
gem 'actionmailer', '~>6.1.7.10' # Email composition, delivery, and receiving with Action Mailer
gem 'actionpack', '~>6.1.7.10' # Handles web requests and responses with Action Controller and Action Dispatch
gem 'actiontext', '~>6.1.7.10' # Rich text content and editing with Action Text
gem 'activestorage' # Handles file uploads in Rails applications
gem 'mutex_m' # Being removed from Ruby soon, required for activestorage
gem 'rails', '~> 6.1.7.10' # The Rails framework
gem 'sprockets-rails', '~> 3.4' # Sprockets adapter for Rails, needed for deploy:assets:precompile steps
gem 'sqlite3', '~> 1.4' # SQLite3 database adapter for ActiveRecord

# Standard Library Enhancements
gem 'abbrev', '~> 0.1.2' # Provides abbreviations for strings, useful for command-line apps
gem 'base64', '~> 0.2.0' # Handling Base64 encoding, explicitly included for upcoming Ruby version changes
gem 'csv', '~> 3.3' # Ruby's standard CSV library, ensure the latest features and fixes
gem 'drb', '~> 2.2' # Distributed Ruby, enables communication between Ruby programs on different machines
gem 'nkf', '~> 0.2.0' # A Japanese text processing library for converting character encodings
gem 'observer', '~> 0.1.2' # Implements the observer design pattern for event-driven programming
gem 'racc', '~> 1.8' # A LALR(1) parser generator for Ruby, useful for creating parsers
gem 'resolv-replace', '~> 0.1.1' # Replaces the default DNS resolver with a Ruby-based resolver
gem 'rinda', '~> 0.2.0' # Provides a distributed coordination system based on the Linda model
gem 'syslog', '~> 0.1.2' # Provides a way to send messages to the system logger

# Server and Performance
gem 'puma' # A fast, multithreaded, and highly concurrent web server for Ruby/Rack applications

# Frontend and Styles
gem 'bootstrap', '~> 5.3.3' # Front-end framework for developing responsive, mobile-first projects
gem 'jquery-rails' # Provides jQuery and the jQuery UJS driver for Rails
gem 'jsbundling-rails' # Manages JavaScript bundling with modern tools like Webpack or esbuild
gem 'sassc-rails', '~> 2.1' # SASSC adapter for Rails, needed for Bootstrap 5
gem 'turbolinks', '~> 5' # Makes navigating your site faster by using AJAX to load only the HTML needed

# Authentication and Authorization
gem 'cancancan' # Authorization library for Ruby on Rails which restricts what resources a given user is allowed to access
gem 'devise' # Flexible authentication solution for Rails with Warden

# Additional Functionality
gem 'nokogiri' # HTML, XML, SAX, and Reader parser
gem 'pagy' # Pagination library that is fast, lightweight, and flexible
gem 'paper_trail' # Track changes to your models' data
gem 'pdfkit' # Uses wkhtmltopdf to generate PDFs from HTML
gem 'rexml', '>= 3.3.6' # XML processing library, now a direct dependency for security management
gem 'wkhtmltopdf-binary', '>= 0.12.6.7' # Enables PDF generation from HTML

# Windows specific timezone data
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Timezone data for Windows

group :development, :test do
  # Debugging tools
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Debugging tool for Ruby

  # Testing libraries
  gem 'factory_bot_rails' # A fixtures replacement with a straightforward definition syntax
  gem 'rails-controller-testing' # Adds missing helper methods for controller tests in Rails 5
  gem 'rspec_junit_formatter' # Outputs RSpec results in JUnit format
  gem 'rspec-rails', '~> 6.0.0' # RSpec for Rails 6+
  gem 'selenium-webdriver', '~> 4.18.1' # WebDriver for testing web applications

  # Coverage and code analysis
  gem 'brakeman', '~> 5.1', '>= 5.1.1' # Static analysis security vulnerability scanner for Ruby on Rails applications
  gem 'coveralls_reborn' # Provides Ruby API for Coveralls.io code coverage reporting
  gem 'rubocop' # A Ruby static code analyzer and formatter
  gem 'rubocop-rails' # A RuboCop extension focused on enforcing Rails best practices
  gem 'simplecov', require: false # Code coverage analysis tool for Ruby
  gem 'simplecov-lcov', require: false # Formatter for SimpleCov that generates LCOV reports

  # Security dependencies
  gem 'bcrypt_pbkdf' # A key derivation function for safely storing passwords
  gem 'ed25519' # Ed25519 elliptic curve public-key signature system
end

group :development do
  # Deployment tools using Capistrano
  gem 'capistrano' # A remote server automation and deployment tool
  gem 'capistrano-bundler', require: false # Capistrano integration for Bundler
  gem 'capistrano-rails', require: false # Integrates Rails with Capistrano
  gem 'capistrano-rvm', require: false # RVM integration for Capistrano
  gem 'capistrano-spec' # RSpec matchers for Capistrano

  # Security tools
  gem 'bundler-audit' # Patch-level verification for Bundler dependencies

  # Development enhancers
  gem 'spring' # Preloads your application for faster testing and Rake task runs
  gem 'spring-watcher-listen', '~> 2.0.0' # Listens to file system events for Spring
  gem 'web-console', '>= 3.3.0' # An interactive console for Rails
end

group :test do
  gem 'capybara', '>= 2.15' # Integration testing tool for rack-based web applications
  gem 'database_cleaner-active_record' # Strategies for cleaning databases in Ruby
  gem 'launchy' # Opens a given URL in a browser
end

group :production do
  gem 'mysql2' # MySQL database adapter for ActiveRecord
  gem 'rb-readline' # Pure Ruby Readline implementation
end
