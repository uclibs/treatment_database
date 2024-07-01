# frozen_string_literal: true

class DataExportJob < ApplicationJob
  require 'rake'
  queue_as :default

  def perform(*_args)
    load_rake_tasks unless Rake::Task.task_defined?('export:all_data')
    Rake::Task['export:all_data'].reenable # Ensures the task can be executed again if needed
    Rake::Task['export:all_data'].invoke
  end

  private

  def load_rake_tasks
    Rails.application.load_tasks
  end
end
