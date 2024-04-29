# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'view conservation record details' do
  it "allows the user to navigate from the index to a conservation record's detail page" do
    visit conservation_records_path
    within('table tbody') do
      first('a').click # The first link in the row is the title of the conservation record.
    end

    # Validate that we are on the correct page
    expect(page).to have_content('Item Detail')
    expect(page).to have_link('Return to List')
    expect(page).to have_content('In-House Repairs')
    expect(page).to have_content('External Repairs')
    expect(page).to have_content('Conservators and Technicians')
    expect(page).to have_content('Treatment Report')
    expect(page).to have_button('Save Treatment Report', disabled: :all) # Disabled but present for read-only users
    expect(page).to have_content('Cost and Return Information')
    expect(page).to have_button('Save Cost and Return Information', disabled: :all) # Disabled but present for read-only users
    expect(page).to have_button('Save Treatment Report', disabled: :all) # Disabled but present for read-only users
    expect(page).to have_button('Save Cost and Return Information', disabled: :all) # Disabled but present for read-only users
  end
end
