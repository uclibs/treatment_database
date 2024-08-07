# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Seeding data', type: :feature do
  # The following seeds are samples of those loaded in db/seeds.rb,
  # which also loads from other files in the db directory.
  # This test checks that the seeds load correctly.
  it 'loads appropriately from seeds' do
    expect(User.find_by(display_name: 'John Green')).not_to be_nil
    expect(ControlledVocabulary.find_by(vocabulary: 'contract_conservator', key: 'William Minter')).not_to be_nil
    expect(ControlledVocabulary.find_by(vocabulary: 'repair_type', key: 'Corrugated clamshell box')).not_to be_nil
    expect(ControlledVocabulary.find_by(vocabulary: 'department', key: 'PLCH')).not_to be_nil
    expect(ControlledVocabulary.find_by(vocabulary: 'housing', key: 'Corrugated clamshell')).not_to be_nil
    expect(ConservationRecord.find_by(title: 'The Great Gatsby')).not_to be_nil
  end
end
