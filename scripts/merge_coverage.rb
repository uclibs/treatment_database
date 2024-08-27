# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'
require 'coveralls'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true

# Collate the coverage data from all parallel jobs
SimpleCov.collate Dir['coverage/*'] do
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::LcovFormatter,
      Coveralls::SimpleCov::Formatter
    ]
  )
  SimpleCov.result.format!
end
