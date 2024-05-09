# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'edits staff codes' do
  it 'edits a staff code' do
    click_on 'Staff Codes'
    expect(page).to have_selector('h1', text: 'Staff Codes')

    all('a[href$="/edit"]', exact_text: 'Edit', visible: true)[0].click
    expect(page).to have_selector('h1', text: 'Editing Staff Code')

    fill_in 'Code', with: 'Updated Code'
    fill_in 'Points', with: 77

    click_on 'Update Staff code'

    expect(flash_notice).to have_content('Staff code was successfully updated')
    expect(page).to have_content('Updated Code')
    expect(page).to have_content('77')

    visit staff_codes_path
    expect(page).to have_content('Updated Code')
    expect(page).to have_content('77')
  end
end
