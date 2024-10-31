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
    @original_shib_login_url = ENV.fetch('SHIBBOLETH_LOGIN_URL', nil)
    ENV['SHIBBOLETH_LOGIN_URL'] = 'http://test.host/login'
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new(env))
    Rails.application.reload_routes!
  end

  def reset_environment
    ENV['SHIBBOLETH_LOGIN_URL'] = @original_shib_login_url
    allow(Rails).to receive(:env).and_return(@original_env)
    Rails.application.reload_routes!
  end
end
