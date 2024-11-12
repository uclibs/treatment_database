# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserConcern', type: :controller do

  # Create an anonymous controller that inherits from ApplicationController
  controller(ApplicationController) do
    include UserConcern

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

  describe '#current_user' do
    context 'when session contains a valid user_id' do
      let(:user) { create(:user) }

      before do
        session[:user_id] = user.id
      end

      it 'returns the user associated with the session user_id' do
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context 'when session does not contain a user_id' do
      before do
        session[:user_id] = nil
      end

      it 'returns nil' do
        expect(controller.send(:current_user)).to be_nil
      end
    end

    context 'when @current_user is already set' do
      let(:user) { create(:user) }
      let(:other_user) { create(:user) }

      before do
        # Manually set @current_user to a user
        controller.instance_variable_set(:@current_user, user)
        # Set session[:user_id] to a different user's ID
        session[:user_id] = other_user.id
        # Allow User.find_by to be called, but we expect it not to be
        allow(User).to receive(:find_by).and_call_original
      end

      it 'returns the memoized @current_user without querying the database' do
        expect(User).not_to receive(:find_by)
        expect(controller.send(:current_user)).to eq(user)
      end
    end
  end

  describe '#user_signed_in?' do
    context 'when current_user is present' do
      before do
        allow(controller).to receive(:current_user).and_return(build_stubbed(:user))
      end

      it 'returns true' do
        expect(controller.send(:user_signed_in?)).to be true
      end
    end

    context 'when current_user is nil' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'returns false' do
        expect(controller.send(:user_signed_in?)).to be false
      end
    end
  end

  describe '#admin?' do
    context 'when current_user is an admin' do
      before do
        allow(controller).to receive(:current_user).and_return(build_stubbed(:user, role: 'admin'))
      end

      it 'returns true' do
        expect(controller.send(:admin?)).to be true
      end
    end

    context 'when current_user is not an admin' do
      before do
        allow(controller).to receive(:current_user).and_return(build_stubbed(:user, role: 'standard'))
      end

      it 'returns false' do
        expect(controller.send(:admin?)).to be false
      end
    end

    context 'when there is no current_user' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'returns false' do
        expect(controller.send(:admin?)).to be false
      end
    end
  end

  describe '#check_user_active' do
    before do
      allow(controller).to receive(:flash).and_return(ActionDispatch::Flash::FlashHash.new)
      allow(controller).to receive(:redirect_to)
    end

    context 'when current_user is active' do
      before do
        allow(controller).to receive(:current_user).and_return(build_stubbed(:user, account_active: true))
        controller.send(:check_user_active)
      end

      it 'does not set a flash alert' do
        expect(controller.flash[:alert]).to be_nil
      end

      it 'does not redirect the user' do
        expect(controller).not_to have_received(:redirect_to)
      end
    end

    context 'when current_user is inactive' do
      before do
        allow(controller).to receive(:current_user).and_return(build_stubbed(:user, account_active: false))
        controller.send(:check_user_active)
      end

      it 'sets a flash alert' do
        expect(controller.flash[:alert]).to eq('Your account is not active.')
      end

      it 'redirects to root_path' do
        expect(controller).to have_received(:redirect_to).with(root_path)
      end
    end
  end

  describe '#handle_successful_login' do
    let(:user) { build_stubbed(:user) }

    before do
      allow(controller).to receive(:reset_session)
      allow(controller).to receive(:redirect_user_based_on_status)
      controller.send(:handle_successful_login, user, 'Welcome!')
    end

    it 'resets the session' do
      expect(controller).to have_received(:reset_session)
    end

    it 'sets session[:user_id] to the user id' do
      expect(session[:user_id]).to eq(user.id)
    end

    it 'sets session[:last_seen] to the current time' do
      expect(session[:last_seen]).to be_within(3.seconds).of(Time.current)
    end

    it 'logs a successful login message' do
      expect(Rails.logger).to have_received(:info).with("User #{user.username} logged in successfully.")
    end

    it 'calls redirect_user_based_on_status with the user and notice message' do
      expect(controller).to have_received(:redirect_user_based_on_status).with(user, 'Welcome!')
    end
  end

  describe '#redirect_user_based_on_status' do
    before do
      allow(controller).to receive(:redirect_to)
    end

    context 'when user account is active' do
      let(:user) { build_stubbed(:user, account_active: true) }

      before do
        controller.send(:redirect_user_based_on_status, user, 'Welcome!')
      end

      it 'redirects to conservation_records_path with a notice' do
        expect(controller).to have_received(:redirect_to).with(conservation_records_path, notice: 'Welcome!')
      end
    end

    context 'when user account is inactive' do
      let(:user) { build_stubbed(:user, account_active: false) }

      before do
        controller.send(:redirect_user_based_on_status, user, 'Welcome!')
      end

      it 'redirects to root_path with an alert about account inactivity' do
        expect(controller).to have_received(:redirect_to).with(root_path, alert: 'Your account is not active.')
      end
    end
  end
end
