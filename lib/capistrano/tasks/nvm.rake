# frozen_string_literal: true

namespace :nvm do
  task :load do
    on roles(:all) do
      within release_path do
        execute :echo, 'Sourcing NVM, installing Node version, and setting Node version'
        execute "source ~/.nvm/nvm.sh && nvm install $(cat #{release_path}/.nvmrc) && nvm use $(cat #{release_path}/.nvmrc)"
      end
    end
  end
end
