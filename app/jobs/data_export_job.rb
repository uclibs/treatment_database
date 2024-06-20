# frozen_string_literal: true

class DataExportJob < ApplicationJob
  require 'rake'

  queue_as :default

  def perform(*_args)
    Rake::Task['export:all_data'].reenable # Ensures the task can be executed again if needed
    Rake::Task['export:all_data'].invoke
  end
end
