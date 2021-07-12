# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin User Tests', type: :feature do
  it 'asks user to login to view Conservation Records' do
    visit root_path
    expect(page).to have_link('Log in')
    expect(page).not_to have_link('Sign up')
    expect(page).to have_link('Conservation Records')
    click_on 'Conservation Records'
    expect(page).to have_content('You need to sign in or sign up before continuing')
  end
end
