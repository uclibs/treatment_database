# frozen_string_literal: true

module TestEnvironmentHelper
  def with_environment(env)
    original_env = Rails.env
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new(env))
    Rails.application.reload_routes!
    yield
  ensure
    # Reset the environment and routes to their original state
    allow(Rails).to receive(:env).and_return(original_env)
    Rails.application.reload_routes!
  end
end
