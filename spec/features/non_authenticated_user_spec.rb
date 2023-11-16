# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin User Tests', type: :feature do
  it 'asks user to login to view Conservation Records' do
    visit root_path
    expect(page).to have_link('Log in')
    expect(page).not_to have_link('Sign up')
  end
end
