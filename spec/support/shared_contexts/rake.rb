# frozen_string_literal: true

RSpec.shared_context 'rake', shared_context: :metadata do
  before(:all) do
    Rails.application.load_tasks
    Dir.glob(Rails.root.join('lib', 'capistrano', 'tasks', '*.rake')).each { |file| load file }
  end

  after(:each) do
    Rake.application.clear
  end
end