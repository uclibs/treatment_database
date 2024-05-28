# frozen_string_literal: true

namespace :deploy do
  desc 'Check required environment variables'
  task :check_env_vars do
    on roles(:app) do
      execute :echo, 'Checking if SHIBBOLETH_SSO_ENABLED is set...'
      shibboleth_enabled = capture(:echo, '$SHIBBOLETH_SSO_ENABLED')
      if shibboleth_enabled.empty?
        error 'SHIBBOLETH_SSO_ENABLED environment variable is not set'
        exit 1
      else
        info "SHIBBOLETH_SSO_ENABLED is set to '#{shibboleth_enabled}'. Deployment can proceed."
      end
    end
  end
end
