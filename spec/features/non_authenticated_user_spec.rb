# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin User Tests', type: :feature do
  it 'asks user to login to view Conservation Records' do
    visit root_path
    expect(page).to have_button('Sign In')
    expect(page).not_to have_button('Sign Up')
  end
end
