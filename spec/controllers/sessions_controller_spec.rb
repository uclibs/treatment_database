# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let(:user) { create(:user) }
  let(:shibboleth_logout_url) { 'https://libappstest.libraries.uc.edu/Shibboleth.sso/Logout' }

  describe 'GET #new' do
    context 'when the user is already signed in' do
      before do
        request_login_as(user)
      end

      it 'redirects to the target path if provided' do
        get login_path, params: { target: conservation_records_path }
        expect(response).to redirect_to(conservation_records_path)
      end

      it 'redirects to the root path if no target is provided' do
        get login_path
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when the user is not signed in' do
      before do
        request_logout
      end

      it 'processes Shibboleth login' do
        # Use a partial double to spy on the SessionsController instance
        controller_instance = nil
        allow_any_instance_of(SessionsController).to receive(:process_shibboleth_login) do |controller|
          controller_instance = controller
          # Ensure the method is actually called
          expect(controller).to be_a(SessionsController)
        end

        get login_path

        # Verify that process_shibboleth_login was indeed called
        expect(controller_instance).not_to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow_any_instance_of(SessionsController).to receive(:shibboleth_logout_url).and_return(shibboleth_logout_url)
    end

    context 'when the user is logged in' do
      before do
        request_login_as(user)
      end

      it 'resets the session and cookies' do
        expect_any_instance_of(SessionsController).to receive(:reset_session_and_cookies)
        delete logout_path, headers: { 'ACCEPT' => 'application/json' }
      end

      it 'responds with the Shibboleth logout URL in JSON' do
        delete logout_path, headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json_response = response.parsed_body
        expect(json_response['shibboleth_logout_url']).to eq(shibboleth_logout_url)
      end
    end

    context 'when the user is not logged in' do
      it 'resets the session and cookies' do
        expect_any_instance_of(SessionsController).to receive(:reset_session_and_cookies)
        delete logout_path, headers: { 'ACCEPT' => 'application/json' }
      end

      it 'responds with the Shibboleth logout URL in JSON' do
        delete logout_path, headers: { 'ACCEPT' => 'application/json' }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        json_response = response.parsed_body
        expect(json_response['shibboleth_logout_url']).to eq(shibboleth_logout_url)
      end
    end
  end
end
