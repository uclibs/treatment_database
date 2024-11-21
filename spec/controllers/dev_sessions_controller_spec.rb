# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DevSessionsController, type: :controller do
  describe 'GET #new' do
    it 'renders the development login form' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      it 'logs in the user and redirects to the appropriate path' do
        post :create, params: { email: user.email, password: 'notapassword' } # Password is set in the factory
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(conservation_records_path)
        expect(flash[:notice]).to eq('Signed in successfully. (Development)')
      end
    end

    context 'with invalid credentials' do
      it 're-renders the login form with an alert' do
        post :create, params: { email: user.email, password: 'wrongpassword' }
        expect(session[:user_id]).to be_nil
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('Invalid email or password')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    before do
      # Simulate a logged-in user
      session[:user_id] = user.id
      session[:last_seen] = Time.current
    end

    it 'logs out the user and redirects to the root path with a notice' do
      delete :destroy

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Signed out successfully. (Development)')
    end
  end
end
