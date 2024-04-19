# frozen_string_literal: true

# Sets up and logs in an admin user for tests, using aggregate_failures to
# report all login-related issues at once.
RSpec.shared_context "read-only user context", shared_context: :metadata do
  let(:user) { create(:user, role: 'read_only') }

  before(:each) do
    user
    log_in_as_user(user)
  end
end