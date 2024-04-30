# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user, role: 'admin') }
  before do
    controller_login_as(user)
    controller_stub_authorization(user)
  end

  let(:valid_attributes) do
    {
      display_name: 'Test User',
      password: 'notapass',
      password_confirmation: 'notapass',
      email: 'testuser123@uc.edu',
      role: 'standard',
      account_active: user.account_active,
      username: 'testuser123'
    }
  end

  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User and redirects' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid params' do
      it 'does not create a new User and re-renders the new template' do
        expect do
          post :create, params: { user: valid_attributes.except(:email) }
        end.not_to change(User, :count)
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) do
      {
        email: 'newemail@uc.edu',
        display_name: 'New Display Name',
        role: 'standard',
        account_active: true
      }
    end

    it 'updates the user and redirects to the admin users index' do
      put :update, params: { id: user.id, user: new_attributes }
      user.reload
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:notice]).to eq('Profile updated successfully.')
      expect(user.display_name).to eq(new_attributes[:display_name])
      expect(user.email).to eq(new_attributes[:email])
      expect(user.role).to eq(new_attributes[:role])
      expect(user.account_active).to be true
    end
  end

  context 'when the user is inactive' do
    let(:inactive_user) { create(:user, role: 'admin', account_active: false) }

    before do
      controller_logout
      controller_login_as(inactive_user)
      controller_stub_authorization(inactive_user)
    end

    it 'blocks access for the inactive user and redirects to the root path' do
      get :index
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('Your account is not active.')
    end
  end
end
