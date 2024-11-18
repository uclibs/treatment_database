# frozen_string_literal: true

# spec/controllers/dummy_controller_spec.rb

require 'rails_helper'

RSpec.describe 'AnonymousController with AuthenticationHelper', type: :controller do
  controller(ApplicationController) do
    include AuthenticationHelper

    def index
      render plain: 'Hello, world!'
    end
  end

  let(:user) { create(:user, role: 'standard', account_active: true) }
  let(:admin_user) { create(:user, role: 'admin', account_active: true) }
  let(:inactive_user) { create(:user, account_active: false) }

  describe 'before_action callbacks' do
    context 'when user is not signed in' do
      context 'in development' do
        it 'redirects to the root page and alerts the user to sign in' do
          with_environment('development') do
            get :index
            expect(response).to redirect_to(root_path)
            expect(flash[:alert]).to eq('You need to sign in before continuing.')
          end
        end
      end
      context 'in production' do
        it 'redirects to the root page and alerts the user to sign in' do
          with_environment('production') do
            get :index
            expect(response).to redirect_to(root_path)
            expect(flash[:alert]).to eq('You need to sign in before continuing.')
          end
        end
      end
    end

    context 'when user is signed in' do
      before do
        session[:user_id] = user.id
        get :index
      end

      it 'does not redirect' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user account is inactive' do
      before do
        session[:user_id] = inactive_user.id
        get :index
      end

      it 'redirects to root with an alert' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end
  end

  describe '#admin?' do
    context 'when the user is an admin' do
      before do
        controller.instance_variable_set(:@current_user, admin_user) # Set @current_user directly
      end

      it 'returns true' do
        expect(controller.admin?).to be true
      end
    end

    context 'when the user is not an admin' do
      before do
        controller.instance_variable_set(:@current_user, user) # Set @current_user directly
      end

      it 'returns false' do
        expect(controller.admin?).to be false
      end
    end
  end
end
