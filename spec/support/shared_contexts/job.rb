# frozen_string_literal: true

RSpec.shared_context 'job', shared_context: :metadata do
  after(:each) do
    # Clean up anything that could affect other tests
    DatabaseCleaner.clean
  end
end
