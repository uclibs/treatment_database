# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7.7'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use rails-controller-testing for testing a controller
gem 'rails-controller-testing'
# Use coveralls for code-coverage
# gem 'coveralls', '~> 0.8.22', require: false
gem 'coveralls_reborn'
# Use rubocop for static code analysis
gem 'rubocop'
# Use simplecov to generate the coveralls report in .html format
gem 'simplecov', require: false
gem 'simplecov-lcov', require: false
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'nokogiri', '>= 1.13'
# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# Use devise for authentication
gem 'devise'

gem 'activestorage', '>= 5.2.6.3'

gem 'bootstrap', '~> 4.3.1'

gem 'jquery-rails'

gem 'pdfkit'

gem 'dotenv-rails'

gem 'cancancan'

gem 'paper_trail'

gem 'pagy'

gem 'brakeman', '~> 5.1', '>= 5.1.1'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'bcrypt_pbkdf'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano', '3.17.1'
  gem 'capistrano-bundler', '~> 1.6', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm', require: false
  gem 'database_cleaner'
  gem 'ed25519'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails', '~> 4.1.0'
  gem 'rubocop-rails'
  gem 'selenium-webdriver', '~> 4.18.1'
end

group :development do
  gem 'bundler-audit'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  # Easy installation and use of chromedriver to run system tests with Chrome
end

group :production do
  # Needed to get console working in production mode
  # gem 'aws-xray-sdk', require: ['aws-xray-sdk/facets/rails/railtie']
  gem 'mysql2'
  gem 'rb-readline'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# wkhtmltopdf uclibs fork
gem 'wkhtmltopdf-binary', git: 'https://github.com/uclibs/wkhtmltopdf_binary_gem', branch: '153/oracle-linux-support'
