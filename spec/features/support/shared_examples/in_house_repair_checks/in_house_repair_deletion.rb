# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'deletes in-house repairs' do
  let(:conservation_record) { create(:conservation_record) }

  before do
    conservation_record
  end

  it 'deletes an in-house repair' do
    add_in_house_repair(conservation_record)
    expect(page).to have_content("Mend paper performed by #{user.display_name}")

    accept_confirm do
      find("a[id='delete_in_house_repair_record_1']").click
    end
    expect(page).not_to have_content("Mend paper performed by #{user.display_name}")
  end
end
