# frozen_string_literal: true

module TestEnvironmentHelper
  def with_environment(env)
    setup_environment(env)
    yield
  ensure
    reset_environment
  end

  private

  def setup_environment(env)
    @original_env = Rails.env
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new(env))
    Rails.application.reload_routes!
  end

  def reset_environment
    allow(Rails).to receive(:env).and_return(@original_env)
    Rails.application.reload_routes!
  end
end
