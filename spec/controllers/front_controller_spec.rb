# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrontController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    context 'when logged_out parameter is present' do
      it 'sets the flash notice' do
        get :index, params: { logged_out: 'true' }

        expect(flash.now[:notice]).to eq('You have successfully signed out.')
      end
    end

    context 'when logged_out parameter is absent' do
      it 'does not set the flash notice' do
        get :index

        expect(flash.now[:notice]).to be_nil
      end
    end
  end
end
