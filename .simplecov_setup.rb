# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'
require 'coveralls'

# Configure LCOV Formatter for Coveralls
SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

# Start SimpleCov for Rails
SimpleCov.start 'rails' do
  command_name "RSpec_#{ENV.fetch('CIRCLE_NODE_INDEX', '0')}" # Unique command name per node
  coverage_dir "coverage/#{ENV.fetch('CIRCLE_NODE_INDEX', '0')}" # Store results in unique directories per node
  add_filter '/spec/'
  add_filter '/lib/tasks/'
  add_filter '/lib/capistrano/'
end

# Only format individual results on parallel nodes
SimpleCov.at_exit do
  SimpleCov.result.format! if ENV['CIRCLE_NODE_INDEX'] # Only format individual results
end
