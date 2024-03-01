# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConTechRecordsHelper, type: :helper do
  let(:conservation_record) { create(:conservation_record) }
  let(:user) { create(:user, display_name: 'Haritha Vytla') }
  let(:user_record) do
    create(:con_tech_record,
           performed_by_user_id: user.id,
           conservation_record:)
  end
  it 'generates a Conservators and Technicians string' do
    expect(helper.generate_con_tech_string(user_record, 0)).to eq('1. Haritha Vytla')
  end
end
