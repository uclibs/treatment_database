# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { create(:user, role: 'admin') }
  before do
    sign_in user
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

  describe 'PUT update/:id' do
    let(:attr) do
      { email: 'newemail@example.com',
        display_name: 'New Display Name',
        role: 'standard_user',
        account_active: true }
    end

    before(:each) do
      put :update, params: { id: user.id, user: attr }
      user.reload
    end

    it { expect(response).to redirect_to(users_path) }
    it { expect(user.display_name).to eql attr[:display_name] }
    it { expect(user.email).to eql attr[:email] }
    it { expect(user.role).to eql attr[:role] }
    it { expect(user.account_active).to be attr[:account_active] }
  end

  context 'user is inactive' do
    let(:user) { create(:user, role: 'admin', account_active: false) }

    before do
      sign_in user
    end

    it 'blocks session for inactive user' do
      get :index
      expect(flash[:alert]).to eq('Your account is not activated yet.')
    end
  end
end
