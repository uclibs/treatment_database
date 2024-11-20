# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shibboleth Authentication', type: :request do
  let(:user) { create(:user, username: 'jdoe', role: 'admin') }

  describe '#process_shibboleth_login' do
    context 'when Shibboleth attributes are present' do
      before do
        # Set the Shibboleth header
        @shib_header = 'jdoe@example.com'
        @username = 'jdoe'
      end

      context 'and the user exists in the system' do
        it 'logs in the user and redirects to the target path' do
          user

          # Simulate the Shibboleth header
          get '/shibboleth_login', headers: { 'X-Shib-User' => @shib_header }

          # expect(response).to redirect_to(conservation_records_path)
          follow_redirect!

          expect(session[:user_id]).to eq(user.id)
          expect(session[:last_seen]).to be_within(1.second).of(Time.current)
        end
      end

      context 'but the user does not exist in the system' do
        it 'redirects to root_path with an alert' do
          # Ensure no user exists with the given username
          User.where(username: @username).destroy_all

          get shibboleth_login_path, headers: { 'X-Shib-User' => @shib_header }

          expect(response).to redirect_to(root_path)
          follow_redirect!

          expect(flash[:alert]).to eq('Sign in failed: User not found.')
          expect(session[:user_id]).to be_nil
        end
      end

      context 'but the username cannot be extracted' do
        before do
          @shib_header = '@example.com' # Invalid username
        end

        it 'redirects to root_path with an alert' do
          get shibboleth_login_path, headers: { 'X-Shib-User' => @shib_header }

          expect(response).to redirect_to(root_path)
          follow_redirect!

          expect(flash[:alert]).to eq('Sign in failed: User not found.')
          expect(session[:user_id]).to be_nil
        end
      end
    end

    context 'when Shibboleth attributes are missing' do
      it 'redirects to root_path with an alert' do
        get shibboleth_login_path

        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(flash[:alert]).to eq('Authentication failed: Shibboleth attributes not present.')
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe 'Edge Cases' do
    context 'when the Shibboleth header is present but empty' do
      it 'handles missing username gracefully' do
        get shibboleth_login_path, headers: { 'X-Shib-User' => '' }

        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(flash[:alert]).to eq('Authentication failed: Shibboleth attributes not present.')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when the Shibboleth header has no username before the @ symbol' do
      it 'handles invalid username format' do
        get shibboleth_login_path, headers: { 'X-Shib-User' => '@example.com' }

        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(flash[:alert]).to eq('Sign in failed: User not found.')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when multiple @ symbols are present in the Shibboleth header' do
      it 'extracts the correct username' do
        # Username with multiple @ symbols
        shib_header = 'john@doe@example.com'
        username = 'john'

        create(:user, username: username)

        get shibboleth_login_path, headers: { 'X-Shib-User' => shib_header }

        expect(response).to redirect_to(conservation_records_path)
        follow_redirect!

        expect(session[:user_id]).to eq(User.find_by(username: username).id)
      end
    end

    context 'when a target parameter is provided' do
      it 'redirects to the specified target path after login' do
        user

        target_path = admin_users_path

        get shibboleth_login_path, headers: { 'X-Shib-User' => 'jdoe@example.com' }, params: { target: target_path }

        expect(response).to redirect_to(target_path)
      end
    end
  end
end
