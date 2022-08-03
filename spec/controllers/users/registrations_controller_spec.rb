# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:user) { create(:user, role: 'admin') }

  describe 'PUT update/:id' do
    let(:attr) do
      { email: 'newemail@example.com',
        id: user.id,
        display_name: 'New Display Name',
        role: 'standard_user',
        current_password: user.password,
        account_active: true }
    end

    before do
      sign_in user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      put :update, params: { user: attr }
      user.reload
    end

    it { expect(response).to redirect_to(root_path) }
    it { expect(flash[:notice]).to eq('Your account has been updated successfully.') }
    it { expect(user.display_name).to eql attr[:display_name] }
    it { expect(user.email).to eql attr[:email] }
    it { expect(user.role).to eql attr[:role] }
    it { expect(user.account_active).to be attr[:account_active] }
  end

  describe 'sign up' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      get :new
    end

    it { expect(response).to redirect_to(new_user_session_path) }
    it { expect(flash[:notice]).to eq('Contact admin to request account') }
  end
end
