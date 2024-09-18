# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CallbacksController, type: :controller do
  describe 'GET #shibboleth' do
    it 'returns a plain text response' do
      get :shibboleth
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('Shibboleth callback received')
    end
  end
end
