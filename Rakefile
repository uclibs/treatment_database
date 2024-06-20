# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

if Rake::Task.tasks.empty?
  Rails.application.load_tasks
  Rails.root.glob('lib/capistrano/tasks/*.rake').each { |file| load file }
end
