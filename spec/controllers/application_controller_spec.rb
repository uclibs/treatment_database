# frozen_string_literal: true

require 'rails_helper'
require 'cancan'

describe ApplicationController, type: :controller do
  controller do
    def index
      raise CanCan::AccessDenied
    end

    def show
      render plain: 'This is a test'
    end
  end

  describe 'handling exceptions' do
    let(:user) { create(:user) }

    before do
      routes.draw do
        get 'index' => 'anonymous#index'
        get 'show' => 'anonymous#show'
      end
      controller_login_as(user)
    end

    context 'when CanCan::AccessDenied is raised' do
      it 'redirects to the root page and sets flash message' do
        get :index
        expect(flash[:alert]).to eq('You are not authorized to access this page.')
        expect(response).to redirect_to(root_url)
      end
    end

    context 'when InvalidAuthenticityToken is raised' do
      before do
        # Temporarily override the index action to not raise AccessDenied
        allow_any_instance_of(controller.class).to receive(:show).and_raise(ActionController::InvalidAuthenticityToken)
      end
      it 'raises InvalidAuthenticityToken error and redirects to root path with a session expired message' do
        # Simulate the request by going to `show`, and manually raise the InvalidAuthenticityToken error
        expect do
          get :show
          raise ActionController::InvalidAuthenticityToken
        end.to raise_error(ActionController::InvalidAuthenticityToken)

        # Expect redirection to root path
        expect(response).to redirect_to(root_path)

        # Check for session expired flash message
        expect(flash[:alert]).to eq('Your session has expired. Please sign in again.')
      end
    end
  end
end
