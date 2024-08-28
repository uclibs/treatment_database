# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'
require 'coveralls'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                  SimpleCov::Formatter::LcovFormatter,
                                                                  SimpleCov::Formatter::HTMLFormatter,
                                                                  Coveralls::SimpleCov::Formatter
                                                                ])

# Enable merging of results across parallel runs
SimpleCov.start 'rails' do
  enable_coverage :branch
  merge_timeout 3600 # Ensure there's enough time to merge results across jobs
  add_filter '/spec/'
  add_filter '/lib/tasks/'
  add_filter '/lib/capistrano/'
end
