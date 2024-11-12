# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShibbolethAuthenticationConcern', type: :controller do
  # Create an anonymous controller that inherits from ApplicationController
  controller(ApplicationController) do
    include ShibbolethAuthenticationConcern

    def index
      render plain: 'Success'
    end
  end

  before do
    # Define routes for the anonymous controller
    routes.draw { get 'index' => 'anonymous#index' }

    # Stub logger methods to prevent actual logging during tests
    allow(Rails.logger).to receive(:error)
    allow(Rails.logger).to receive(:info)
  end

  describe '#process_shibboleth_login' do
    context 'when username is found in Shibboleth attributes' do
      before do
        allow(controller).to receive(:find_shibboleth_username).and_return('testuser')
        allow(controller).to receive(:authenticate_user_with_username)
        controller.send(:process_shibboleth_login)
      end

      it 'calls authenticate_user_with_username with the username' do
        expect(controller).to have_received(:authenticate_user_with_username).with('testuser')
      end
    end

    context 'when username is not found in Shibboleth attributes' do
      before do
        allow(controller).to receive(:find_shibboleth_username).and_return(nil)
        allow(controller).to receive(:handle_missing_username)
        controller.send(:process_shibboleth_login)
      end

      it 'calls handle_missing_username' do
        expect(controller).to have_received(:handle_missing_username)
      end
    end
  end

  describe '#handle_missing_username' do
    before do
      allow(controller).to receive(:log_missing_attribute_error)
      allow(controller).to receive(:redirect_to)
      controller.send(:handle_missing_username)
    end

    it 'logs the missing attribute error' do
      expect(controller).to have_received(:log_missing_attribute_error)
    end

    it 'redirects to root_path with an alert' do
      expect(controller).to have_received(:redirect_to).with(root_path, alert: 'Authentication failed: Username attribute not present.')
    end
  end

  describe '#authenticate_user_with_username' do
    context 'when user is found' do
      let(:user) { create(:user, username: 'testuser', account_active: true) }

      before do
        allow(User).to receive(:find_by).with(username: 'testuser').and_return(user)
        allow(controller).to receive(:handle_successful_login)
        controller.send(:authenticate_user_with_username, 'testuser')
      end

      it 'calls handle_successful_login with the user and success message' do
        expect(controller).to have_received(:handle_successful_login).with(user, 'Signed in successfully.')
      end
    end

    context 'when user is not found' do
      before do
        allow(User).to receive(:find_by).with(username: 'unknownuser').and_return(nil)
        allow(controller).to receive(:handle_user_not_found)
        controller.send(:authenticate_user_with_username, 'unknownuser')
      end

      it 'calls handle_user_not_found' do
        expect(controller).to have_received(:handle_user_not_found)
      end
    end
  end

  describe '#shibboleth_attributes_present?' do
    context 'when Shibboleth attributes are present' do
      before do
        request.env['uid'] = 'testuser'
      end

      it 'returns true' do
        expect(controller.send(:shibboleth_attributes_present?)).to be true
      end
    end

    context 'when Shibboleth attributes are not present' do
      before do
        # Ensure request.env does not have Shibboleth attributes
        request.env.delete('uid')
        request.env.delete('eppn')
        request.env.delete('REMOTE_USER')
        request.env.delete('HTTP_UID')
        request.env.delete('HTTP_EPPN')
        request.env.delete('HTTP_REMOTE_USER')
      end

      it 'returns false' do
        expect(controller.send(:shibboleth_attributes_present?)).to be false
      end
    end
  end

  describe '#find_shibboleth_username' do
    context 'when uid is present in request.env' do
      before do
        request.env['uid'] = 'testuser_uid'
      end

      it 'returns the uid value' do
        expect(controller.send(:find_shibboleth_username)).to eq('testuser_uid')
      end
    end

    context 'when eppn is present in request.env' do
      before do
        request.env['eppn'] = 'testuser_eppn'
      end

      it 'returns the eppn value' do
        expect(controller.send(:find_shibboleth_username)).to eq('testuser_eppn')
      end
    end

    context 'when REMOTE_USER is present in request.env' do
      before do
        request.env['REMOTE_USER'] = 'testuser_remote'
      end

      it 'returns the REMOTE_USER value' do
        expect(controller.send(:find_shibboleth_username)).to eq('testuser_remote')
      end
    end

    context 'when none of the attributes are present' do
      before do
        # Ensure request.env does not have the attributes
        request.env.delete('uid')
        request.env.delete('eppn')
        request.env.delete('REMOTE_USER')
        request.env.delete('HTTP_UID')
        request.env.delete('HTTP_EPPN')
        request.env.delete('HTTP_REMOTE_USER')
      end

      it 'returns nil' do
        expect(controller.send(:find_shibboleth_username)).to be_nil
      end
    end
  end

  describe '#log_missing_attribute_error' do
    it 'logs an error message' do
      expect(Rails.logger).to receive(:error).with('Shibboleth username attribute not present in request.env.')
      controller.send(:log_missing_attribute_error)
    end
  end

  describe '#handle_user_not_found' do
    before do
      allow(controller).to receive(:reset_session_and_cookies)
      allow(controller).to receive(:redirect_to)
      controller.send(:handle_user_not_found)
    end

    it 'resets session and cookies' do
      expect(controller).to have_received(:reset_session_and_cookies)
    end

    it 'redirects to root_path with an alert' do
      expect(controller).to have_received(:redirect_to).with(root_path, alert: 'Sign in failed: User not found')
    end
  end
end
