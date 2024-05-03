# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'creates new controlled vocabularies' do
  it 'creates a new controlled vocabulary' do
    visit controlled_vocabularies_path
    expect(page).to have_selector('h1', text: 'Controlled Vocabularies')

    click_link('New Controlled Vocabulary')
    expect(page).to have_selector('h1', text: 'New Controlled Vocabulary')

    select 'department', from: 'Vocabulary'
    fill_in 'Key', with: 'Silly Walks'
    check 'Active'
    click_button 'Create Controlled vocabulary'

    expect(flash_notice).to have_content('Controlled vocabulary was successfully created')
    expect(page).to have_selector('p', text: 'Silly Walks')

    click_on 'Return to List'
    last_row = all('table tr').last
    expect(last_row).to have_selector('td', text: 'department')
    expect(last_row).to have_link('Silly Walks')
  end
end
