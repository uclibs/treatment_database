# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  # include SamlHelper

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:inactive_user) { create(:user, account_active: false) }

  let(:shib_attributes) do
    {
      'Shib-Attributes' => {
        uid: user.username,
        givenName: 'TestFirstName',
        sn: 'TestLastName'
      }
    }
  end

  let(:inactive_shib_attributes) do
    {
      'Shib-Attributes' => {
        uid: inactive_user.username,
        givenNae: 'InactiveFirstName',
        sn: 'InactiveLastName'
      }
    }
  end

  let(:shib_attributes_invalid_user) do
    {
      'Shib-Attributes' => {
        uid: 'nonexistent_user',
        givenName: 'TestFirstName',
        sn: 'TestLastName'
      }
    }
  end

  let(:shib_attributes_missing_username) do
    {
      'Shib-Attributes' => {
        givenName: 'TestFirstName',
        sn: 'TestLastName'
      }
    }
  end

  describe 'GET #new' do
    it 'redirects to Shibboleth login URL' do
      allow(controller).to receive(:shibboleth_callback_url).and_return('http://test.host/shibboleth_callback')

      with_environment('production') do
        get :new
        expected_url = "#{ENV.fetch('SHIBBOLETH_LOGIN_URL', nil)}?target=#{CGI.escape('http://test.host/shibboleth_callback')}"

        expect(response).to redirect_to(expected_url)
      end
    end
  end

  # describe 'GET #shibboleth_callback' do
  #   context 'successful login' do
  #     before do
  #       request.env.merge!(shib_attributes)
  #     end
  #
  #     it 'logs in the user and redirects to conservation_records_path' do
  #       with_environment('production') do
  #         get :shibboleth_callback
  #         expect(session[:user_id]).to eq(user.id)
  #         expect(response).to redirect_to(conservation_records_path)
  #         expect(flash[:notice]).to eq('Signed in successfully.')
  #       end
  #     end
  #
  #     it 'logs out existing user and logs in new user' do
  #       session[:user_id] = another_user.id # Simulate an existing session
  #       get :shibboleth_callback
  #       expect(session[:user_id]).to eq(user.id) # The new user should now be logged in
  #     end
  #   end
  #
  #   context 'unsuccessful login' do
  #     shared_examples 'failed login due to' do |error_message|
  #       it 'redirects to root_path with an alert' do
  #         get :shibboleth_callback
  #         expect(session[:user_id]).to be_nil
  #         expect(response).to redirect_to(root_path)
  #         expect(flash[:alert]).to eq(error_message)
  #       end
  #     end
  #
  #     before { session[:user_id] = another_user.id } # Simulate existing session
  #
  #     context 'inactive account' do
  #       before { request.env.merge!(inactive_shib_attributes) }
  #
  #       it 'does not log in and redirects with an account inactive alert' do
  #         get :shibboleth_callback
  #         expect(session[:user_id]).to eq(inactive_user.id)
  #         expect(response).to redirect_to(root_path)
  #         expect(flash[:alert]).to eq('Your account is not active.')
  #       end
  #     end
  #
  #     context 'user not found in app user list' do
  #       before { request.env.merge!(shib_attributes_invalid_user) }
  #       include_examples 'failed login due to', 'Sign in failed: User not found'
  #     end
  #
  #     context 'missing username in Shibboleth attributes' do
  #       before { request.env.merge!(shib_attributes_missing_username) }
  #       include_examples 'failed login due to', 'Sign in failed: Shibboleth username is missing.'
  #     end
  #
  #     context 'missing first name in Shibboleth attributes' do
  #       before { request.env.merge!('Shib-Error' => 'Sign in failed: Required Shibboleth attributes missing') }
  #
  #       it 'clears the session and cookies and redirects' do
  #         get :shibboleth_callback
  #         expect(session[:user_id]).to be_nil
  #         expect(cookies.to_hash).to be_empty
  #         expect(response).to redirect_to(root_path)
  #         expect(flash[:alert]).to eq('Sign in failed: Shibboleth username is missing.')
  #       end
  #     end
  #
  #     context 'Shibboleth attributes are nil' do
  #       before { request.env.merge!('Shib-Attributes' => nil) }
  #
  #       it 'clears the session and cookies and redirects' do
  #         get :shibboleth_callback
  #         expect(session[:user_id]).to be_nil
  #         expect(cookies.to_hash).to be_empty
  #         expect(response).to redirect_to(root_path)
  #         expect(flash[:alert]).to eq('Sign in failed: Shibboleth username is missing.')
  #       end
  #     end
  #   end
  # end

  describe 'DELETE #destroy' do
    context 'when the user is active' do
      before do
        controller_login_as(user)
        session[:user_id] = user.id
      end

      it 'logs out the user, resets session, clears cookies, and redirects to Shibboleth logout URL' do
        with_environment('production') do
          ENV['SHIBBOLETH_LOGOUT_URL'] = 'http://test.host/logout'

          allow(controller).to receive(:root_url).and_return('http://test.host/')

          expect(session[:user_id]).to eq(user.id)

          delete :destroy

          expect(session[:user_id]).to be_nil
          expect(cookies.to_hash).to be_empty

          expected_redirect_url = "http://test.host/logout?target=#{CGI.escape('http://test.host/')}"

          expect(response).to redirect_to(expected_redirect_url)
          expect(flash[:notice]).to eq('Signed out successfully')
        end
      end
    end

    context 'when the user is inactive' do
      before do
        controller_login_as(inactive_user)
        session[:user_id] = inactive_user.id
      end

      it 'logs out the user and redirects to Shibboleth logout URL' do
        ENV['SHIBBOLETH_LOGOUT_URL'] = 'http://test.host/logout'
        allow(controller).to receive(:root_url).and_return('http://test.host/')

        delete :destroy

        expected_redirect_url = "http://test.host/logout?target=#{CGI.escape('http://test.host/')}"

        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(expected_redirect_url)
      end
    end
  end

  # describe 'GET #metadata' do
  #   # More extensive testing of the metadata template is done in the view spec
  #   # at: spec/views/authentication/metadata.xml.erb_spec.rb
  #   # and the SamlHelper spec at: spec/helpers/saml_helper_spec.rb
  #   it 'renders the metadata template with XML content type' do
  #     get :metadata, format: :xml
  #
  #     expect(response).to have_http_status(:ok)
  #     expect(response).to render_template('sessions/metadata')
  #     expect(response.content_type).to include('xml')
  #   end
  # end
end
