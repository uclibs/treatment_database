# frozen_string_literal: true

RSpec.shared_examples 'can create conservation records' do
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms', department: 2) }

  it 'can create conservation records' do
    # Add New Conservation Record
    visit conservation_records_path
    click_on 'New Conservation Record'
    expect(page).to have_content('New Conservation Record')
    fill_in 'Date received in preservation services', with: '04/15/2024'
    select('ARB Library', from: 'Department', match: :first)
    fill_in 'Title', with: conservation_record.title
    fill_in 'Author', with: conservation_record.author
    fill_in 'Imprint', with: conservation_record.imprint
    fill_in 'Call number', with: conservation_record.call_number
    fill_in 'Item record number', with: conservation_record.item_record_number
    click_on 'Create Conservation record'
    expect(page).to have_content('Conservation record was successfully created')
    expect(page).to have_content(conservation_record.title)
    expect(page).to have_link('Edit Conservation Record')
  end
end

RSpec.shared_examples 'cannot create conservation records' do
  it 'does not allow creating conservation records' do
    visit conservation_records_path
    expect(page).to have_content('Conservation Records')
    expect(page).to have_no_link('New Conservation Record')
  end
end
