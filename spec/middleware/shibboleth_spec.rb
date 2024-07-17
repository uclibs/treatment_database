# frozen_string_literal: true
require 'rails_helper'
require 'rack/test'
require_relative '../../lib/middleware/shibboleth'

RSpec.describe Middleware::Shibboleth do
  include Rack::Test::Methods

  def app
    Rack::Builder.new do
      use Middleware::Shibboleth
      run ->(env) { [200, env, [""]] }
    end.to_app
  end

  it 'extracts Shibboleth attributes and adds them to env' do
    # Simulate a request with Shibboleth attributes
    env = { 'mail' => 'test@example.com', 'uid' => 'testuser', 'givenName' => 'Test', 'sn' => 'User'}
    get '/', {}, env

    expect(last_request.env['Shib-Attributes'][:email]).to eq('test@example.com')
    expect(last_request.env['Shib-Attributes'][:username]).to eq('testuser')
    expect(last_request.env['Shib-Attributes'][:first_name]).to eq('Test')
    expect(last_request.env['Shib-Attributes'][:last_name]).to eq('User')
  end
end
