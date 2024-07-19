# frozen_string_literal: true

module Middleware
  class Shibboleth
    def initialize(app)
      @app = app
    end

    def call(env)
      # Directly pass the request environment along
      @app.call(env)
    end
  end
end
