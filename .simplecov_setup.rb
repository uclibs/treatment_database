# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'
require 'coveralls'

# Configure LCOV Formatter for Coveralls
SimpleCov::Formatter::LcovFormatter.config do |config|
  config.report_with_single_file = true
  config.output_directory = 'coverage/lcov' # Ensure the LCOV report is stored here
  config.lcov_file_name = 'lcov.info'       # Set the file name to 'lcov.info'
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                  SimpleCov::Formatter::LcovFormatter,     # Generates LCOV file for Coveralls
                                                                  SimpleCov::Formatter::HTMLFormatter      # Generates the HTML coverage report
                                                                ])

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
