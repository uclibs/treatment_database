# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:admin_user) { create(:user, role: 'admin') }
  let(:standard_user) { create(:user, role: 'standard') }
  let(:inactive_user) { create(:user, role: 'standard', account_active: false) }

  before do
    sign_in admin_user
  end

  let(:valid_attributes) do
    {
      display_name: 'Test User',
      password: 'notapassword',
      confirm_password: 'notapassword',
      email: 'testuser123@x.com',
      role: 'standard',
      account_active: admin_user.account_active
    }
  end

  let(:invalid_attributes) do
    {
      display_name: '',
      email: 'invalidemail.com'
    }
  end

  describe 'GET #index' do
    it 'returns http success for admin user' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'redirects inactive user with alert' do
      sign_in inactive_user
      get :index
      expect(flash[:alert]).to eq('Your account is not activated yet.')
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET #edit' do
    it 'returns http success for admin user' do
      get :edit, params: { id: admin_user.id }
      expect(response).to have_http_status(:success)
    end

    it 'blocks standard user from editing another user' do
      sign_in standard_user
      get :edit, params: { id: admin_user.id }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to be_present
    end
  end

  describe 'POST #create_user' do
    it 'creates a new user with valid params' do
      request.env['HTTP_REFERER'] = new_user_path
      expect {
        post :create_user, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to be_present
    end

    it 'fails to create a user with invalid params' do
      request.env['HTTP_REFERER'] = new_user_path
      expect {
        post :create_user, params: { user: invalid_attributes }
      }.not_to change(User, :count)
      expect(response).to redirect_to(new_user_path)
      expect(flash[:notice]).to eq('Email is invalid')
    end
  end

  describe 'PUT update/:id' do
    let(:new_attributes) do
      {
        email: 'newemail@example.com',
        display_name: 'New Display Name',
        role: 'standard_user',
        account_active: true
      }
    end

    before do
      request.env['HTTP_REFERER'] = edit_user_path(admin_user)
    end

    context 'with valid params' do
      before(:each) do
        put :update, params: { id: admin_user.id, user: new_attributes }
        admin_user.reload
      end

      it 'redirects to the users list' do
        expect(response).to redirect_to(users_path)
      end

      it 'updates the user details' do
        expect(admin_user.display_name).to eq new_attributes[:display_name]
        expect(admin_user.email).to eq new_attributes[:email]
        expect(admin_user.role).to eq new_attributes[:role]
        expect(admin_user.account_active).to be new_attributes[:account_active]
      end
    end

    context 'with invalid params' do
      it 'does not update the user and re-renders edit' do
        put :update, params: { id: admin_user.id, user: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(flash[:alert]).to be_present
      end
    end
  end

  context 'inactive user' do
    before do
      sign_in inactive_user
    end

    it 'blocks session for inactive user on index' do
      get :index
      expect(flash[:alert]).to eq('Your account is not activated yet.')
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'blocks session for inactive user on other actions' do
      get :edit, params: { id: inactive_user.id }
      expect(flash[:alert]).to eq('Your account is not activated yet.')
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
