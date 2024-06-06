# frozen_string_literal: true

namespace :nvm do
  task :load do
    on roles(:all) do
      within release_path do
        # Read the .nvmrc file and install the specified Node.js version
        execute "nvm install $(cat #{release_path}/.nvmrc)"

        # Use the installed Node.js version
        execute "nvm use $(cat #{release_path}/.nvmrc)"
      end
    end
  end
end
