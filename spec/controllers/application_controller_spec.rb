# frozen_string_literal: true

require 'rails_helper'
require 'cancan'

RSpec.describe ApplicationController, type: :controller do
  # Create an anonymous controller for testing
  controller do
    def index
      # For testing CanCan::AccessDenied exception
      raise CanCan::AccessDenied
    end

    def show
      # For testing successful access
      render plain: 'This is a test'
    end
  end

  # Include necessary modules and set up before actions
  before do
    # Include helper modules
    @controller.class.include(AuthenticationConcern)
    @controller.class.include(UserAuthenticationConcern)
    @controller.class.include(SessionManagementConcern)

    # Set up before_action callbacks as in ApplicationController
    @controller.class.before_action :authenticate_user!
    @controller.class.before_action :check_user_active, if: :user_signed_in?
    @controller.class.before_action :validate_session_timeout, if: :user_signed_in?

    # Stub logger methods to prevent actual logging during tests
    allow(Rails.logger).to receive(:error)
    allow(Rails.logger).to receive(:info)

    # Define routes for the anonymous controller
    routes.draw do
      get 'index' => 'anonymous#index'
      get 'show' => 'anonymous#show'
    end
  end

  ## **1. Testing Before Action Callbacks**

  describe 'before_action callbacks' do
    context 'when the user is already signed in and active' do
      let(:user) { create(:user, account_active: true) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
        session[:last_seen] = Time.current
      end

      it 'allows access to the action' do
        get :show
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('This is a test')
      end
    end

    context 'when the user is signed in but account is inactive' do
      let(:user) { create(:user, account_active: false) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
      end

      it 'redirects to root path with an alert about inactive account' do
        get :show
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end

    context 'when the user is signed in but session is expired' do
      let(:user) { create(:user, account_active: true) }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(controller).to receive(:user_signed_in?).and_return(true)
        session[:last_seen] = 11.hours.ago
      end

      it 'expires the session and redirects to root path with an alert' do
        get :show
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your session has expired. Please sign in again.')
        expect(session[:user_id]).to be_nil
      end
    end

    context 'when the user is not signed in and Shibboleth attributes are present' do
      let(:user) { create(:user, account_active: true) }

      before do
        allow(controller).to receive(:user_signed_in?).and_return(false)
        allow(controller).to receive(:shibboleth_attributes_present?).and_return(true)
        allow(controller).to receive(:process_shibboleth_login) do
          allow(controller).to receive(:current_user).and_return(user)
          allow(controller).to receive(:user_signed_in?).and_return(true)
          session[:last_seen] = Time.current
        end
      end

      it 'processes Shibboleth login and allows access' do
        expect(controller).to receive(:process_shibboleth_login)
        get :show
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('This is a test')
      end
    end

    context 'when the user is not signed in and Shibboleth attributes are not present' do
      before do
        allow(controller).to receive(:user_signed_in?).and_return(false)
        allow(controller).to receive(:shibboleth_attributes_present?).and_return(false)
      end

      it 'redirects to root_path with an alert' do
        expect(Rails.logger).to receive(:error).with('Shibboleth attributes not present. Cannot authenticate user.')
        get :show
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Authentication failed: Shibboleth attributes not present.')
      end
    end
  end

  ## **2. Testing Exception Handling**

  describe 'handling exceptions' do
    let(:user) { create(:user, account_active: true) }

    before do
      # Log in the user for these tests
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:user_signed_in?).and_return(true)
    end

    context 'when CanCan::AccessDenied is raised' do
      it 'redirects to the root page and sets flash message' do
        get :index
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when ActionController::InvalidAuthenticityToken is raised' do
      before do
        # Simulate InvalidAuthenticityToken error
        allow_any_instance_of(controller.class).to receive(:show).and_raise(ActionController::InvalidAuthenticityToken)
      end

      it 'handles the exception and redirects with a session expired message' do
        get :show
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your session has expired. Please sign in again.')
      end
    end

    context 'when ActiveRecord::RecordNotFound is raised' do
      before do
        # Simulate RecordNotFound error
        allow_any_instance_of(controller.class).to receive(:show).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'renders the 404 page' do
        get :show
        expect(response).to have_http_status(:not_found)
        expect(response).to render_template('errors/not_found')
      end
    end
  end
end
