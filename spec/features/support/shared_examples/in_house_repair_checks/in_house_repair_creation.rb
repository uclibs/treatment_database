# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'creates new in-house repairs' do
  let(:conservation_record) { create(:conservation_record) }

  before do
    conservation_record
  end

  it 'creates a new in-house repair' do
    add_in_house_repair(conservation_record)

    expect(page).to have_content("Mend paper performed by #{user.display_name}")
  end
end
