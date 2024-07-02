# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'can read but not edit conservation records' do
  let(:cons_record) { create(:conservation_record) }

  before do
    cons_record
  end

  it 'does not have buttons that it should not have' do
    visit conservation_records_path
    expect(page).not_to have_link('New Conservation Record')

    within('table tbody') do
      first('a').click
    end

    expect(page).not_to have_link('Edit Conservation Record')
    expect(page).not_to have_link('Add In-House Repair')
    expect(page).not_to have_link('Add External Repair')
    expect(page).not_to have_link('Add Conservators and Technicians')
  end

  it 'has disabled conservation record buttons' do
    visit conservation_records_path
    within('table tbody') do
      first('a').click
    end

    expect(page).to have_content('Cost and Return Information')
    expect(page).to have_button('Save Cost and Return Information', disabled: true)
    expect(page).to have_button('Save Treatment Report', disabled: true)
    expect(page).to have_button('Save Cost and Return Information', disabled: true)
  end

  it 'has disabled input fields in the conservation record form' do
    visit conservation_record_path(cons_record)
    expect(page).to have_selector('h1', text: cons_record.title)
    expect(page).to have_selector('form.disable_input')
    all('form.disable_input').each do |form| # There are several forms on the page
      within(form) do
        # Check disabled state for all input, textarea, and select elements
        %w[input textarea select].each do |element_type|
          all(element_type).each do |element|
            expect(element).to be_disabled
          end
        end
      end
    end
  end
end
