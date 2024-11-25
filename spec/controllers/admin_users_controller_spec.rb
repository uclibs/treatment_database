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
        display_name: 'Updated Display Name',
        role: 'read_only',
        account_active: true
      }
    end

    let(:unchanged_email) { user.email }

    context 'when updating non-email attributes' do
      it 'updates the user and keeps the email unchanged' do
        put :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq('Profile updated successfully.')
        expect(user.display_name).to eq(new_attributes[:display_name])
        expect(user.role).to eq(new_attributes[:role])
        expect(user.account_active).to eq(new_attributes[:account_active])
        expect(user.email).to eq(unchanged_email) # Ensure email is unchanged
      end
    end

    context 'when attempting to update the email' do
      let(:new_email) { 'new_email@example.com' }

      it 'ignores the email update' do
        put :update, params: { id: user.id, user: new_attributes.merge(email: new_email) }
        user.reload
        expect(response).to redirect_to(admin_users_path)
        expect(flash[:notice]).to eq('Profile updated successfully.')
        expect(user.display_name).to eq(new_attributes[:display_name])
        expect(user.role).to eq(new_attributes[:role])
        expect(user.account_active).to eq(new_attributes[:account_active])
        expect(user.email).to eq(unchanged_email) # Email remains unchanged
      end
    end

    context 'when attributes are invalid' do
      let(:invalid_attributes) { { display_name: '', role: 'standard', account_active: true } }

      it 'does not update the user and re-renders the edit page' do
        put :update, params: { id: user.id, user: invalid_attributes }
        user.reload
        expect(response).to render_template(:edit)
        expect(user.display_name).not_to eq(invalid_attributes[:display_name])
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
