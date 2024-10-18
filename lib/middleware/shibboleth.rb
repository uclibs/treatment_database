# frozen_string_literal: true

module Middleware
  class Shibboleth
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)
      shib_attributes = extract_shibboleth_attributes(request)

      if missing_attributes?(shib_attributes)
        env['Shib-Error'] = 'Sign in failed: Required Shibboleth attributes missing'
      else
        env['Shib-Attributes'] = shib_attributes
      end

      @app.call(env)
    end

    private

    def extract_shibboleth_attributes(request)
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
