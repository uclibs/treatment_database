# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationConcern, type: :controller do
  # Create an anonymous controller that includes the AuthenticationConcern
  controller(ApplicationController) do
    include AuthenticationConcern
    include UserAuthenticationConcern
    include SessionManagementConcern

    # Set up the before_action callback
    before_action :authenticate_user!

    def index
      render plain: 'Welcome to the dashboard'
    end
  end

  before do
    # Define routes for the anonymous controller
    routes.draw { get 'index' => 'anonymous#index' }

    # Stub logger methods to prevent actual logging during tests
    allow(Rails.logger).to receive(:error)
    allow(Rails.logger).to receive(:info)
  end

  describe 'GET #index' do
    context 'when the user is already signed in' do
      let(:user) { create(:user, account_active: true) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end

      it 'allows access to the action' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('Welcome to the dashboard')
      end
    end

    context 'when the user is not signed in' do
      before do
        allow(controller).to receive(:user_signed_in?).and_return(false)
      end

      context 'and Shibboleth attributes are present' do
        let(:user) { create(:user, account_active: true) }

        before do
          allow(controller).to receive(:shibboleth_attributes_present?).and_return(true)
          allow(controller).to receive(:process_shibboleth_login) do
            allow(controller).to receive(:current_user).and_return(user)
            allow(controller).to receive(:user_signed_in?).and_return(true)
          end
        end

        it 'processes Shibboleth login and allows access' do
          expect(controller).to receive(:process_shibboleth_login)
          get :index
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq('Welcome to the dashboard')
        end
      end

      context 'and Shibboleth attributes are not present' do
        before do
          allow(controller).to receive(:shibboleth_attributes_present?).and_return(false)
        end

        it 'logs an error and redirects to root_path with an alert' do
          expect(Rails.logger).to receive(:error).with('Shibboleth attributes not present. Cannot authenticate user.')
          get :index
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Authentication failed: Shibboleth attributes not present.')
        end
      end

      context 'and Shibboleth attributes are present but login fails' do
        before do
          allow(controller).to receive(:shibboleth_attributes_present?).and_return(true)
          allow(controller).to receive(:process_shibboleth_login).and_raise(StandardError.new('Login error'))
        end

        it 'rescues the exception and redirects with an alert' do
          expect(Rails.logger).to receive(:error).with('Login error')
          get :index
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('Authentication failed: An error occurred during login.')
        end
      end
    end


  end
end
