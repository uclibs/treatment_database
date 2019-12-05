# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_navigation.html.erb', type: :view do
  include Devise::Test::ControllerHelpers

  context 'when user is admin' do
    before do
      @user = create(:user, role: 'admin')
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
      render
    end

    it 'has a menu with the expected links when signed out' do
      expect(rendered).to have_link('Conservation Records')
      expect(rendered).to have_link('Vocabularies')
      expect(rendered).to have_link('Log out')
    end
  end

  context 'when user is standard' do
    before do
      @user = create(:user, role: 'standard')
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
      render
    end

    it 'has a menu with the expected links when signed out' do
      expect(rendered).to have_link('Conservation Records')
      expect(rendered).to have_link('Vocabularies')
      expect(rendered).to have_link('Log out')
    end
  end

  context 'when user is read_only' do
    before do
      @user = create(:user, role: 'read_only')
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
      render
    end

    it 'has a menu with the expected links when signed out' do
      expect(rendered).to have_link('Conservation Records')
      expect(rendered).not_to have_link('Vocabularies')
      expect(rendered).to have_link('Log out')
    end
  end
end
