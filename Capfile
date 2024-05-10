# frozen_string_literal: true

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

# Include default deployment SCM plugin
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# Include tasks from the `lib/capistrano/tasks` directory
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

task :use_rvm do
  require 'capistrano/rvm'
end

task local: :use_rvm
