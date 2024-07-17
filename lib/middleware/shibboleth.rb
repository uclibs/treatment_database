module Middleware
  class Shibboleth
    def initialize(app)
      @app = app
    end

    def call(env)
      request = Rack::Request.new(env)

      # Extract Shibboleth attributes from the request environment
      shib_attributes = {
        email: request.env['mail'],
        username: request.env['uid'],
        first_name: request.env['givenName'],
        last_name: request.env['sn']
      }

      # Store Shibboleth attributes in the environment
      env['Shib-Attributes'] = shib_attributes

      @app.call(env)
    end
  end
end

