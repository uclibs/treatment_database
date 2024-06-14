# frozen_string_literal: true

# Shared context for RSpec that loads all Rails and custom Capistrano rake tasks before
# each test suite and clears the Rake environment after each individual test. This ensures
# that each test starts with a fresh set of tasks and no residual state interferes with
# subsequent tests.
# This is invoked in spec/rails_helper.rb with the line `config.include_context 'rake', type: :task`,
# which adds the shared context to all tests of type :task.
RSpec.shared_context 'rake', shared_context: :metadata do
  before(:all) do
    Rails.application.load_tasks
    # Rails.root.glob('lib/capistrano/tasks/*.rake').each { |file| load file }
  end

  after(:each) do
    Rake.application.clear
  end
end
