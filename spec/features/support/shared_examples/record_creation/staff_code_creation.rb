# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'creates new staff codes' do
  it 'creates a new staff code' do
    click_on 'Staff Codes'
    expect(page).to have_selector('h1', text: 'Staff Codes')
    click_on 'New Staff Code'
    expect(page).to have_selector('h1', text: 'New Staff Code')

    fill_in 'Code', with: 'Test Code'
    fill_in 'Points', with: 10

    click_on 'Create Staff code'

    expect(flash_notice).to have_content('Staff code was successfully created')
    click_on 'Back'

    expect(page).to have_selector('h1', text: 'Staff Codes')
    expect(page).to have_content('Test Code')
  end
end
