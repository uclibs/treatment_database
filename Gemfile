# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Core framework
gem 'rails', '~> 6.1.7.7'

# Database
gem 'sqlite3' # SQLite as the database for Active Record, suitable for development and testing

# Web server
gem 'puma' # Puma as the app server

# Front-end assets
gem 'bootstrap', '~> 4.3.1' # Styling framework
gem 'coffee-rails', '~> 4.2' # CoffeeScript support
gem 'dotenv-rails' # Load environment variables from `.env`
gem 'jsbundling-rails' # JavaScript bundling with esbuild, Webpack, or rollup.js
gem 'sass-rails', '~> 5.0' # SCSS stylesheets
gem 'uglifier', '>= 1.3.0' # JavaScript compression

# Utilities
gem 'bootsnap', '>= 1.1.0', require: false # Speed up boot time by caching expensive operations
gem 'brakeman', '~> 5.1', '>= 5.1.1' # Security vulnerability scanning
gem 'nokogiri', '>= 1.13' # XML and HTML parsing
gem 'pdfkit' # HTML to PDF conversion

# Authentication & Authorization
gem 'cancancan' # Authorization library
gem 'devise' # User authentication

# API support
gem 'jbuilder', '~> 2.5' # JSON templating

# Changes tracking
gem 'paper_trail' # Model versioning for auditing changes

# Pagination
gem 'pagy' # Efficient pagination

# Development and testing tools
group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw] # Debugging in MRI and mingw environments
  gem 'database_cleaner' # Database cleaning strategies
  gem 'factory_bot_rails' # Test data factories
  gem 'launchy' # Open files in the browser
  gem 'rspec_junit_formatter' # Formatter for RSpec output compatible with JUnit
  gem 'rspec-rails', '~> 4.1.0' # RSpec for Rails
  gem 'rubocop', require: false # Ruby code style checking
  gem 'rubocop-rails' # Rails-specific analysis for RuboCop
  gem 'selenium-webdriver' # Browser automation for testing
end

# Development-only tools
group :development do
  gem 'bundler-audit' # Vulnerability scanning for Gemfile
  gem 'spring' # Application preloader
  gem 'spring-watcher-listen', '~> 2.0.0' # File changes watcher compatible with Spring
  gem 'web-console', '>= 3.3.0' # Rails console in the browser

  # Deployment automation
  gem 'capistrano', '3.17.1'
  gem 'capistrano-bundler', '~> 1.6', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm', require: false

  # SSH keys authentication
  gem 'bcrypt_pbkdf'
  gem 'ed25519'
end

# Testing tools
group :test do
  gem 'capybara', '>= 2.15' # Integration testing
  gem 'coveralls_reborn', require: false # Test coverage reporting
  gem 'rails-controller-testing' # Testing Rails controllers
  gem 'simplecov', require: false # Code coverage analysis
  gem 'simplecov-lcov', require: false # LCov formatter for SimpleCov
end

# Production-only gems
group :production do
  gem 'mysql2' # MySQL as the production database
  gem 'rb-readline' # Ruby implementation of readline for console sessions
end

# Platform-specific gems
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby] # Timezone data for Windows/JRuby

# Custom forks or versions not available on RubyGems
gem 'wkhtmltopdf-binary', git: 'https://github.com/uclibs/wkhtmltopdf_binary_gem', branch: '153/oracle-linux-support' # HTML to PDF conversion support
