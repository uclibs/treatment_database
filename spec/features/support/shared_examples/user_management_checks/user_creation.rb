# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'creates new users' do
  it 'creates a new user' do
    visit users_path
    expect(page).to have_selector('h1', text: 'Users')
    expect(page).to have_link('Add New User', href: new_user_path)
    click_on 'Add New User'
    expect(page).to have_selector('h1', text: 'Create New User')

    fill_in 'Display name', with: 'Daffy Duck'
    fill_in 'Email', with: 'daffyduck@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    select 'Standard', from: 'user_role'

    click_on 'Create User'

    expect(flash_notice).to have_content('Successfully created User.')
    expect(page).to have_selector('h1', text: 'Users')
    expect(page).to have_content('Daffy Duck')
    row = find('tr', text: 'Daffy Duck')
    within(row) do
      expect(row).to have_content('daffyduck@example.com')
      expect(row).to have_content('standard')
    end
  end
end
