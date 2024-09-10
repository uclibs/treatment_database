# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { create(:user, role: 'admin') }
  let(:extra_user) { create(:user) }


  before do
    controller_login_as(user)
    controller_stub_authorization(user)
  end

  let(:valid_attributes) do
    {
      display_name: 'Test User',
      password: 'notapassword',
      password_confirmation: 'notapassword',
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

    let(:invalid_attributes) do
      {
        email: nil, # Invalid because email is required
        display_name: 'New Display Name',
        role: 'standard',
        account_active: true
      }
    end

    context 'with valid attributes' do
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
    context 'with invalid attributes' do
      before do
        @original_display_name = user.display_name
        @original_email = user.email
        put :update, params: { id: user.id, user: invalid_attributes }
        user.reload
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end

      it 'sets a flash error message' do
        expect(flash[:alert]).to eq('There was a problem editing the user. Please check the errors below.')
      end

      it 'does not update the user attributes' do
        expect(user.display_name).to eq(@original_display_name)
        expect(user.email).to eq(@original_email)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow user deletion and redirects with an alert' do
      delete :destroy, params: { id: extra_user.id }

      # Ensure the user is not destroyed
      expect(User.exists?(extra_user.id)).to be_truthy

      # Ensure it redirects to the admin users path with the proper alert
      expect(response).to redirect_to(admin_users_path)
      expect(flash[:alert]).to eq('User deletion is not permitted.')
    end
  end
end
