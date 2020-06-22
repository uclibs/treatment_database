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
    it 'redirects to the root page and sets flash message' do
      get :index
      flash[:notice].should eq('You are not authorized to access this page.')
      response.should redirect_to(root_url)
    end
  end
end
