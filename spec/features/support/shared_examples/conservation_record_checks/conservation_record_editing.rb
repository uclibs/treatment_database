# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'edits conservation records' do
  let(:conservation_record) { create(:conservation_record) }
  let(:old_title) { conservation_record.title }

  before do
    conservation_record
    old_title
    visit conservation_records_path
  end

  it 'edits conservation records' do
    expect(page).to have_link('Conservation Records', href: conservation_records_path)
    expect(page).to have_link(conservation_record.title, href: conservation_record_path(conservation_record))
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_selector('h1', text: conservation_record.title)

    expect(page).to have_link('Edit Conservation Record', href: edit_conservation_record_path(conservation_record))
    expect(page).to have_selector('h1', text: old_title)
    click_link('Edit Conservation Record')

    expect(page).to have_selector('h1', text: 'Editing Conservation Record')
    fill_in 'Title', with: 'An Updated Title'
    expect(page).to have_button('Update Conservation record')
    click_on 'Update Conservation record'

    expect(flash_notice).to have_content('Conservation record was successfully updated')
    expect(page).to have_selector('h1', text: 'An Updated Title')
    expect(page).not_to have_content(old_title)
  end
end
