# frozen_string_literal: true

class DataExportJob < ApplicationJob
  require 'rake'
  TreatmentDatabase::Application.load_tasks

  queue_as :default

  def perform(*_args)
    Rake::Task['export:all_data'].execute
  end
end
