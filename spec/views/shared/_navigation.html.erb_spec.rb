# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_navigation.html.erb', type: :view do
  include Devise::Test::ControllerHelpers

  before do
    create(:user)
    render
  end

  it 'has a menu with the expected links when signed out' do
    expect(rendered).to have_link('Conservation Records')
    expect(rendered).to have_link('Vocabularies')
    expect(rendered).to have_link('Log in')
    expect(rendered).to have_link('Sign up')
  end
end
