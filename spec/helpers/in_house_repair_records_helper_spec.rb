# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InHouseRepairRecordsHelper, type: :helper do
  let(:conservation_record) { create(:conservation_record) }
  let(:repair_type) { create(:controlled_vocabulary, vocabulary: 'repair_type', key: 'Wash') }
  let(:user) { create(:user, display_name: 'John Q. Public') }
  let!(:staff_code) { create(:staff_code, code: 'C', points: 10) }

  let(:repair_record) do
    create(:in_house_repair_record,
           performed_by_user_id: user.id,
           repair_type: repair_type.id,
           conservation_record:,
           other_note: 'Please check spine',
           staff_code_id: '1')
  end

  it 'generates an in house repair string' do
    expect(helper.generate_in_house_repair_string(repair_record,
                                                  0)).to eq('1. Wash performed by John Q. Public in 10 minutes. Other note: Please check spine. Staff Code: C')

    expect(helper.generate_in_house_repair_string(repair_record,
                                                  nil)).to eq('Wash performed by John Q. Public in 10 minutes. Other note: Please check spine. Staff Code: C')
  end

  it 'returns user not found text for non-existent user id' do
    repair_record.performed_by_user_id = 99_999
    expect(helper.generate_in_house_repair_string(repair_record,
                                                  nil)).to eq('Wash performed by User not found (ID: 99999) in 10 minutes. Other note: Please check spine. Staff Code: C')
  end
end
