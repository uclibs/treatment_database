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
    end

    it 'raises an error' do
      expect { put :update, params: { user: attr } }.to raise_error ActionController::UrlGenerationError
    end
  end
end
