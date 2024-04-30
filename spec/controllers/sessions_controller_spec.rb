# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:inactive_user) { create(:user, account_active: false) }

  let(:shib_attributes) do
    {
      'Shib-Attributes' => {
        email: user.email,
        username: user.username,
        first_name: 'TestFirstName',
        last_name: 'TestLastName'
      }
    }
  end

  let(:inactive_shib_attributes) do
    {
      'Shib-Attributes' => {
        email: inactive_user.email,
        username: inactive_user.username,
        first_name: 'InactiveFirstName',
        last_name: 'InactiveLastName'
      }
    }
  end

  let(:shib_attributes_invalid_user) do
    {
      'Shib-Attributes' => {
        email: 'nonexistent_user@example.com',
        username: 'nonexistent_user',
        first_name: 'TestFirstName',
        last_name: 'TestLastName'
      }
    }
  end

  let(:shib_attributes_missing_username) do
    {
      'Shib-Attributes' => {
        email: user.email,
        first_name: 'TestFirstName',
        last_name: 'TestLastName'
      }
    }
  end

  describe 'GET #new' do
    it 'redirects to Shibboleth login URL' do
      allow(controller).to receive(:shibboleth_callback_url).and_return('http://test.host/shibboleth_callback')

      with_environment('production') do
        get :new
        expect(response).to redirect_to("#{SessionsController::SHIBBOLETH_LOGIN_URL}?target=#{shibboleth_callback_url}")
      end
    end
  end

  describe 'GET #shibboleth_callback' do
    context 'successful login' do
      before do
        request.env.merge!(shib_attributes)
      end

      it 'logs in the user and redirects to conservation_records_path' do
        get :shibboleth_callback
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(conservation_records_path)
        expect(flash[:notice]).to eq('Signed in successfully via Shibboleth')
      end

      it 'logs out existing user and logs in new user' do
        session[:user_id] = another_user.id # Simulate an existing session
        get :shibboleth_callback
        expect(session[:user_id]).to eq(user.id) # The new user should now be logged in
      end
    end

    context 'unsuccessful login' do
      shared_examples 'failed login due to' do |error_message|
        it 'redirects to root_path with an alert' do
          get :shibboleth_callback
          expect(session[:user_id]).to be_nil
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq(error_message)
        end
      end

      before { session[:user_id] = another_user.id } # Simulate existing session

      context 'inactive account' do
        before { request.env.merge!(inactive_shib_attributes) }

        it 'does not log in and redirects with an account inactive alert' do
          get :shibboleth_callback
          expect(session[:user_id]).to eq(inactive_user.id)
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Your account is not active.')
        end
      end

      context 'user not found in app user list' do
        before { request.env.merge!(shib_attributes_invalid_user) }
        include_examples 'failed login due to', 'Login failed: Username not found'
      end

      context 'missing username in Shibboleth attributes' do
        before { request.env.merge!(shib_attributes_missing_username) }
        include_examples 'failed login due to', 'Login failed: Username not found'
      end

      context 'Shibboleth error present' do
        before { request.env.merge!('Shib-Error' => 'Some arbitrary error message') }
        include_examples 'failed login due to', 'Some arbitrary error message'
      end

      context 'missing Shibboleth attributes' do
        before { request.env.merge!('Shib-Error' => 'Login failed: Required Shibboleth attributes missing') }

        it 'clears the session and cookies and redirects' do
          get :shibboleth_callback
          expect(session[:user_id]).to be_nil
          expect(cookies.to_hash).to be_empty
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Login failed: Required Shibboleth attributes missing')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the user is active' do
      before do
        controller_login_as(user)
        session[:user_id] = user.id
      end

      it 'logs out the user, resets session, clears cookies, and redirects to Shibboleth logout URL' do
        with_environment('production') do
          expect(session[:user_id]).to eq(user.id)
          delete :destroy
          expect(session[:user_id]).to be_nil
          expect(cookies.to_hash).to be_empty # Ensure cookies are cleared
          expect(response).to redirect_to(SessionsController::SHIBBOLETH_LOGOUT_URL.to_s)
          expect(flash[:notice]).to eq('Logged out successfully')
        end
      end
    end

    context 'when the user is inactive' do
      before do
        controller_login_as(inactive_user)
        session[:user_id] = inactive_user.id
      end

      it 'logs out the user and redirects to root path' do
        expect(session[:user_id]).to eq(inactive_user.id)
        delete :destroy
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
