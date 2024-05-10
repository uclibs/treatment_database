# frozen_string_literal: true

namespace :deploy do
  desc 'Confirmation before deploy'
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

  desc 'Remove old assets'
  task :clear_assets do
    on roles(:web) do
      execute :rm, '-rf', release_path.join('public/assets/*')
      execute :rm, '-rf', release_path.join('public/build/*')
    end
  end
end
