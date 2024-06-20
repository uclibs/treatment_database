# frozen_string_literal: true

require 'rake'

if Rake::Task.tasks.empty?
  Rails.application.load_tasks
  Rails.root.glob('lib/capistrano/tasks/*.rake').each { |file| load file }
end