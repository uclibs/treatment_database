# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:inactive_user) { create(:user, account_active: false) }

  describe 'GET #new' do
    it 'returns http success' do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs in the user and redirects to root path' do
        post :create, params: { email: user.email, password: 'notapassword' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Signed in successfully')
      end
    end

    context 'with invalid credentials' do
      it 're-renders the new template with an alert' do
        post :create, params: { email: user.email, password: 'wrongpass' }
        expect(session[:user_id]).to be_nil
        expect(flash.now[:alert]).to eq('Invalid email or password')
        expect(response).to render_template(:new)
      end
    end

    context 'with an inactive account' do
      it 'does not log in and redirects with an alert' do
        post :create, params: { email: inactive_user.email, password: 'notapassword' }
        expect(session[:user_id]).to eq(inactive_user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Your account is not active.')
      end
    end

    context 'with non-existing email' do
      it 'does not find the user and re-renders the new template with an alert' do
        post :create, params: { email: 'nonexistent@example.com', password: 'notapassword' }
        expect(session[:user_id]).to be_nil
        expect(flash.now[:alert]).to eq('Invalid email or password')
        expect(response).to render_template(:new)
      end
    end

    context 'when user is already logged in' do
      before { session[:user_id] = user.id }

      it 'does not override the session if already logged in' do
        post :create, params: { email: user.email, password: 'notapassword' }
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Signed in successfully')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the user is active' do
      before do
        controller_login_as(user)
        session[:user_id] = user.id
      end

      it 'logs out the user and redirects to root path' do
        expect(session[:user_id]).to eq(user.id)
        delete :destroy
        expect(session[:user_id]).to be_nil
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Logged out successfully')
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
        expect(flash[:notice]).to eq('Logged out successfully')
      end
    end
  end
end
