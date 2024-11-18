# frozen_string_literal: true

# spec/requests/session_management_spec.rb

require 'rails_helper'

RSpec.describe 'Session Management', type: :request do
  include ActiveSupport::Testing::TimeHelpers # For manipulating time

  let(:user) { create(:user) }

  describe 'validate_session_timeout' do
    context 'when session has not expired' do
      it 'allows access and updates session[:last_seen]' do
        request_login_as(user)

        # Travel 1 hour into the future
        travel 1.hour

        # Access a protected path
        get conservation_records_path

        # Expect successful access
        expect(response).to have_http_status(:ok)

        # Verify that session[:last_seen] is updated
        last_seen = Time.parse(response.headers['X-Last-Seen'])
        expect(last_seen).to be_within(1.second).of(Time.current)

        # Clean up time travel
        travel_back
      end
    end

    context 'when session has expired' do
      it 'resets the session and redirects to root_path with alert' do
        request_login_as(user)

        # Travel 11 hours into the future to simulate session expiration
        travel 11.hours

        # Attempt to access a protected path
        get conservation_records_path

        # Expect redirection to root_path with alert
        expect(response).to redirect_to(root_path)
        follow_redirect!

        # Check for the alert message
        expect(response.body).to include('Your session has expired. Please sign in again.')

        # Clean up time travel
        travel_back
      end
    end

    context 'when session[:last_seen] is not set' do
      it 'considers session expired, resets the session, and prompts the user to log in again' do
        request_login_as(user)

        # Stub `session[:last_seen]` to return nil when checked in `session_expired?`
        allow_any_instance_of(ApplicationController).to receive(:session).and_return({ last_seen: nil })

        # Attempt to access a protected path
        get conservation_records_path
        follow_redirect!

        # Check for the alert message in the response body
        expect(response.body).to include('You must be signed in to access this page.')
      end
    end
  end

  describe 'session_expired?' do
    it 'resets the session and redirects when expire_session is called' do
      request_login_as(user)

      # Simulate session expiration by traveling in time
      travel 11.hours

      # Attempt to access a protected path
      get conservation_records_path

      # Expect redirection to root_path
      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include('Your session has expired. Please sign in again.')

      # Clean up time travel
      travel_back
    end
  end

  describe 'reset_session_and_cookies' do
    before do
      # Set cookies before the request
      cookies['some_cookie'] = 'value'
      cookies['_non_shib_cookie'] = 'value'
      cookies['_shibsession_123'] = 'shib_value'
      cookies['_shibstate_abc'] = 'state_value'

      # Log in as the user
      request_login_as(user)

      # Perform logout which calls reset_session_and_cookies
      request_logout
    end

    it 'clears the values of non-Shibboleth cookies' do
      expect(cookies['some_cookie']).to eq('')
      expect(cookies['_non_shib_cookie']).to eq('')
    end

    it 'preserves Shibboleth cookies with their original values' do
      expect(cookies['_shibsession_123']).to eq('shib_value')
      expect(cookies['_shibstate_abc']).to eq('state_value')
    end

    it 'resets the session' do
      # Attempt to access a protected path
      get conservation_records_path

      # Expect redirection to root_path since the session is reset
      expect(response).to redirect_to(root_path)
    end
  end
end
