#  frozen_string_literal: true

namespace :yarn do
  desc 'Install yarn packages'
  task :install do
    puts "Capistrano version: #{fetch(:capistrano_version)}"
    on roles(:all) do
      within release_path do
        execute :echo, 'Sourcing NVM and running yarn install'
        execute [
          'source ~/.nvm/nvm.sh &&',
          "nvm use $(cat #{release_path}/.nvmrc) &&",
          "cd #{release_path} &&",
          'RAILS_ENV=production yarn cache clean &&',
          'yarn install'
        ].join(' ')
      end
    end
  end

  task :build do
    on roles(:all) do
      within release_path do
        execute :echo, 'Sourcing NVM and running yarn build'
        execute "source ~/.nvm/nvm.sh && nvm use $(cat #{release_path}/.nvmrc) && cd #{release_path} && RAILS_ENV=production yarn build"
      end
    end
  end
end
