# frozen_string_literal: true

require 'rails_helper'
require 'cancan'
describe ApplicationController, type: :controller do
  controller do
    def index
      raise CanCan::AccessDenied
    end
  end

  describe 'handling AccessDenied exceptions' do
    let(:user) { create(:user) }

    before do
      routes.draw { get 'index' => 'anonymous#index' }
      controller_login_as(user)
    end

    it 'redirects to the root page and sets flash message' do
      get :index
      expect(flash[:alert]).to eq('You are not authorized to access this page.')
      expect(response).to redirect_to(root_url)
    end
  end
end
