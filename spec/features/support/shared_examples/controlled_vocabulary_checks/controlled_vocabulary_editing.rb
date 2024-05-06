# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'edits controlled vocabularies' do
  let(:vocabulary) { create(:controlled_vocabulary, key: 'Surfboarding', active: true) }

  before do
    vocabulary
    visit controlled_vocabularies_path
  end

  it 'edits a controlled vocabulary' do
    expect(page).to have_selector('h1', text: 'Controlled Vocabularies')
    expect(page).to have_content('Surfboarding')
    click_on 'Surfboarding'
    expect(page).to have_selector('h1', text: 'Vocabulary: vocabulary_string')
    click_on 'Edit'
    expect(page).to have_selector('h1', text: 'Editing Controlled Vocabulary')
    fill_in 'Key', with: 'Surfing'
    check 'Favorite'
    click_on 'Update Controlled vocabulary'
    expect(flash_notice).to have_content('Controlled vocabulary was successfully updated')
    expect(page).to have_content('Surfing')
    expect(page).to have_content('Favorite: true')
  end
end
