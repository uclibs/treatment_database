# frozen_string_literal: true

module Middleware
  class Shibboleth
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      Rails.logger.info 'Received request for Shibboleth callback'
      shib_attributes = extract_shibboleth_attributes(request)

      if missing_attributes?(shib_attributes)
        Rails.logger.error 'Missing Shibboleth attributes - inside call method'
        env['Shib-Error'] = 'Login failed: Required Shibboleth attributes missing'
      else
        env['Shib-Attributes'] = shib_attributes
      end

      @app.call(env)
    end

    private

    def extract_shibboleth_attributes(request)
      Rails.logger.debug { "Request env: #{request.env}" }

      Rails.logger.debug { "Shibboleth attributes received: #{request.env.select { |k, _v| k.start_with?('Shib', 'mail', 'uid', 'givenName', 'sn') }}" }
      {
        email: request.env['mail'],
        username: request.env['uid'],
        first_name: request.env['givenName'],
        last_name: request.env['sn']
      }
    end

    def missing_attributes?(shib_attributes)
      shib_attributes.values.any?(&:nil?)
    end
  end
end
