# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin User Tests', skip: 'Temporarily skipping due to Chrome updates before deploy', type: :feature do
  it 'asks user to login to view Conservation Records' do
    visit root_path
    expect(page).to have_button('Sign In')
    expect(page).not_to have_content('Sign Up')
  end
end
