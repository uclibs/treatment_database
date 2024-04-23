# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'view user management' do
  it 'allows viewing the Users page' do
    within('nav.navbar') do
      expect(page).to have_link(nil, href: users_path)
    end
    visit users_path
    expect(page).to have_selector('h1', text: 'Users')
    expect(page).to have_link('Add New User', href: '/users/new', class: 'btn btn-primary')
  end
end
