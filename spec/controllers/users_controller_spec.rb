# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin_user) { create(:user, role: 'admin') }

  describe 'GET #edit' do
    it 'assigns the requested user as @user' do
      controller_login_as(user)
      controller_stub_authorization(user)
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'returns http success' do
      controller_login_as(user)
      controller_stub_authorization(user)
      get :edit, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end

    it 'loads current_user when attempting to edit another user' do
      controller_login_as(user)
      controller_stub_authorization(user)
      get :edit, params: { id: other_user.id }

      # Expect that @user is set to current_user
      expect(assigns(:user)).to eq(user)

      # Ensure the response is successful
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) do
      {
        display_name: 'New Display Name'
      }
    end

    context 'with valid params' do
      it 'updates the user and redirects to the root path' do
        controller_login_as(user)
        controller_stub_authorization(user)
        put :update, params: { id: user.id, user: new_attributes }
        user.reload
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Profile updated successfully.')
        expect(user.display_name).to eq(new_attributes[:display_name])
      end
    end

    context 'with invalid params' do
      it 'does not update the user and re-renders the edit template' do
        controller_login_as(user)
        controller_stub_authorization(user)
        put :update, params: { id: user.id, user: new_attributes.merge(display_name: '') }
        expect(response).to render_template(:edit)
        expect(flash[:notice]).to be_nil
        expect(user.reload.display_name).not_to eq('')
      end
    end
  end
end
