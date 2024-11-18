# frozen_string_literal: true

# spec/requests/user_authentication_spec.rb
require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  let(:active_user) { create(:user, username: 'active_user', account_active: true) }
  let(:inactive_user) { create(:user, username: 'inactive_user', account_active: false) }
  let(:admin_user) { create(:user, username: 'admin_user', role: 'admin', account_active: true) }

  describe 'Accessing protected content' do
    context 'when the user is not authenticated' do
      it 'redirects to root_path with an alert' do
        get '/test_user_auth'

        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.body).to include('You must be signed in to access this page.')
      end
    end

    context 'when the user is authenticated' do
      before { request_login_as(active_user) }

      it 'allows access to the protected content' do
        get '/test_user_auth'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Protected content')
      end
    end

    context 'when the user is inactive' do
      before { request_login_as(inactive_user) }

      it 'redirects to root_path with an alert' do
        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.body).to include('Your account is not active.')
      end

      it 'resets the session' do
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe 'Admin area access' do
    context 'when the user is an admin' do
      before { request_login_as(admin_user) }

      it 'allows access to the admin area' do
        get '/admin_area'

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Admin content')
      end
    end

    context 'when the user is not an admin' do
      before { request_login_as(active_user) }

      it 'denies access with a forbidden status' do
        get '/admin_area'

        expect(response).to have_http_status(:forbidden)
        expect(response.body).to include('Access denied')
      end
    end

    context 'when the user is not authenticated' do
      it 'redirects to root_path with an alert' do
        get '/admin_area'

        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.body).to include('You must be signed in to access this page.')
      end
    end
  end

  describe 'Edge Cases' do
    context 'with an invalid session user_id' do
      it 'redirects to root_path with an alert' do
        get '/test_user_auth', headers: { 'X-Test-Invalid-User' => 'true' }

        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.body).to include('You must be signed in to access this page.')
      end
    end

    context 'when the user becomes inactive after login' do
      before do
        request_login_as(active_user)
        active_user.update(account_active: false)
      end

      it 'redirects to root_path with an alert' do
        get '/test_user_auth'
        expect(response).to redirect_to(root_path)
        follow_redirect!

        expect(response.body).to include('Your account is not active.')
      end

      it 'resets the session' do
        get '/test_user_auth'

        expect(session[:user_id]).to be_nil
      end
    end
  end
end
