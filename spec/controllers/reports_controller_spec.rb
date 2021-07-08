# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  describe 'GET index' do
    it 'returns https success' do
      get :index
      assert_response :success
    end
  end

  describe 'create' do
    it 'returns empty set' do
      post :create
      assert_response :success
    end
  end
end
