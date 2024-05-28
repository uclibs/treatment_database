# These tasks will enable or disable a feature in Flipper.
# The feature name is passed as an argument to the task.
# The task will then enable or disable the feature using the Flipper gem.
# Usage (in the terminal):
# rake 'flipper:enable[my_feature]'
# rake 'flipper:disable[my_feature]'
# For a current list of features, see the Flipper UI at http://localhost:3000/flipper.
# Flipper names should be in lowercase and use underscores instead of spaces.

namespace :flipper do
  desc "Enable a feature"
  task :enable, [:feature] => :environment do |t, args|
    feature = args[:feature]
    $flipper[feature].enable
    puts "Feature '#{feature}' enabled."
  end

  desc "Disable a feature"
  task :disable, [:feature] => :environment do |t, args|
    feature = args[:feature]
    $flipper[feature].disable
    puts "Feature '#{feature}' disabled."
  end
end
