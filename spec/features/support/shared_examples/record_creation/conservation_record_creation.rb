# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'creates new conservation records' do
  let(:conservation_record) { build(:conservation_record) }

  before do
    FactoryBot.create(:controlled_vocabulary, vocabulary: 'department', key: 'PLCH', value: 'Preservation Library Collections and Conservation', active: true)
  end

  it 'creates a new conservation record' do
    click_on 'New Conservation Record'
    expect(page).to have_selector('h1', text: 'New Conservation Record')

    fill_in 'Date received in preservation services', with: '04/15/2024'
    select('PLCH', from: 'Department', match: :first)
    fill_in 'Title', with: conservation_record.title
    fill_in 'Author', with: conservation_record.author
    fill_in 'Imprint', with: conservation_record.imprint
    fill_in 'Call number', with: conservation_record.call_number
    fill_in 'Item record number', with: conservation_record.item_record_number

    click_on 'Create Conservation record'

    expect(flash_notice).to have_content('Conservation record was successfully created')
    expect(page).to have_selector('h1', text: conservation_record.title)
    expect(page).to have_link('Edit Conservation Record')
  end
end
