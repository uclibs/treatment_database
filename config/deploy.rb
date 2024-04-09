# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.1'

set :application, 'treatment_database'
set :repo_url, 'https://github.com/uclibs/treatment_database.git'

task :shared_db do
  on roles(:all) do
    execute "mkdir -p #{fetch(:deploy_to)}/shared/db/ && touch #{fetch(:deploy_to)}/shared/db/development.sqlite3"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
    execute "cp #{fetch(:deploy_to)}/static/.env.development #{fetch(:release_path)}/ || true"
  end
end

task :start_local do
  on roles(:all) do
    execute "export PATH=$PATH:/usr/local/bin && cd #{fetch(:release_path)}/scripts && source start_local.sh"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
  end
end

task :init_qp do
  on roles(:all) do
    execute 'gem install bundler'
    execute "bundle config path 'vendor/bundle' --local"
    execute "mkdir -p #{fetch(:deploy_to)}/static"
    execute "cp #{fetch(:deploy_to)}/static/.env.production #{fetch(:release_path)}/ || true"
  end
end

task :start_qp do
  on roles(:all) do
    execute "cd #{fetch(:release_path)}/ && chmod a+x scripts/* && source scripts/start_qp.sh"
  end
end

task :ruby_update_check do
  on roles(:all) do
    execute "cd #{fetch(:release_path)}/ && chmod a+x scripts/* && source scripts/check_ruby.sh"
  end
end

namespace :deploy do
  desc 'Ensure Node.js and Yarn are installed'
  task :ensure_node_yarn do
    on roles(:web) do
      execute "node -v || { echo 'Node.js is not installed'; exit 1; }"
      execute "yarn -v || { echo 'Yarn is not installed'; exit 1; }"
    end
  end

  desc 'Install JavaScript dependencies'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end

  desc 'Build JavaScript assets'
  task :build_javascript do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && ./bin/rails javascript:build")
      end
    end
  end

  task :confirmation do
    stage = fetch(:stage).upcase
    branch = fetch(:branch)
    puts <<-WARN

    ========================================================================

      *** Deploying to branch `#{branch}` to #{stage} server ***

      WARNING: You're about to perform actions on #{stage} server(s)
      Please confirm that all your intentions are kind and friendly

    ========================================================================

    WARN
    ask :value, "Sure you want to continue deploying `#{branch}` on #{stage}? (Y or Yes)"

    unless fetch(:value).match?(/\A(?i:yes|y)\z/)
      puts "\nNo confirmation - deploy cancelled!"
      exit
    end
  end
end

# Hooks to run the tasks at the correct point in the deployment process
before 'deploy:assets:precompile', 'deploy:yarn_install'
before 'deploy:assets:precompile', 'deploy:build_javascript'
before 'deploy:yarn_install', 'deploy:ensure_node_yarn'

Capistrano::DSL.stages.each do |stage|
  after stage, 'deploy:confirmation'
end
