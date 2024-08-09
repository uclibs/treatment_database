#  frozen_string_literal: true

puts 'Loading Yarn tasks...'
namespace :yarn do
  desc 'Build yarn packages'
  task :build do
    on roles(:all) do
      within release_path do
        execute :echo, 'Sourcing NVM and running yarn build'
        execute "source ~/.nvm/nvm.sh && nvm use $(cat #{release_path}/.nvmrc) && cd #{release_path} && RAILS_ENV=production yarn build"
      end
    end
  end
end
