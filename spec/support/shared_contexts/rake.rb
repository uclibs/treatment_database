# frozen_string_literal: true

# Shared context for RSpec rake task tests.  Makes sure that rake is loaded and re-enables
# tasks before each test.  This is necessary because Rake tasks are single-use and are
# disabled after they are run.  Having this shared context makes test development easier.
#
# This is invoked in spec/rails_helper.rb with the line `config.include_context 'rake', type: :task`,
# which adds the shared context to all tests of type :task.
RSpec.shared_context 'rake', shared_context: :metadata do
  require 'rake' # Ensure Rake is loaded

  before(:each) do
    Rake::Task.tasks.each(&:reenable)
  end
end
