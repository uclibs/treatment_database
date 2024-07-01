# frozen_string_literal: true

namespace :nvm do
  task :setup do
    on roles(:web) do
      SSHKit.config.command_map.prefix[:rake] ||= []

      begin
        execute :echo, 'Checking .nvmrc presence...'
        if test("[ -f #{release_path}/.nvmrc ]")
          execute :echo, 'Sourcing NVM and setting Node version...'
          SSHKit.config.command_map.prefix[:rake].unshift("source ~/.nvm/nvm.sh && nvm use $(cat #{release_path}/.nvmrc) &&")
        else
          error "No .nvmrc file found in #{release_path}"
          exit 1
        end
      rescue SSHKit::Command::Failed => e
        error "NVM setup failed: #{e.message}"
        raise
      end
    end
  end
end
