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
           minutes_spent: 10,
           other_note: 'Please check spine',
           staff_code_id: staff_code.id)
  end

  let(:repair_record_no_note) do
    create(:in_house_repair_record,
           performed_by_user_id: user.id,
           repair_type: repair_type.id,
           conservation_record:,
           minutes_spent: 10,
           staff_code_id: staff_code.id)
  end

  describe '#generate_in_house_repair_string' do
    # Testing with index and all fields present
    it 'generates an in house repair string with index and all fields present' do
      result = helper.generate_in_house_repair_string(repair_record, 0)
      expect(result).to eq('1. Wash performed by John Q. Public in 10 minutes. Other note: Please check spine. Staff Code: C')
    end

    # Testing with index and missing other_note
    it 'generates an in house repair string with index and no other_note' do
      result = helper.generate_in_house_repair_string(repair_record_no_note, 1)
      expect(result).to eq('2. Wash performed by John Q. Public in 10 minutes. Staff Code: C')
    end

    # Testing without index and all fields present
    it 'generates an in house repair string without index but all fields present' do
      result = helper.generate_in_house_repair_string(repair_record, nil)
      expect(result).to eq('Wash performed by John Q. Public in 10 minutes. Other note: Please check spine. Staff Code: C')
    end

    # Testing without index and missing other_note
    it 'generates an in house repair string without index and no other_note' do
      result = helper.generate_in_house_repair_string(repair_record_no_note, nil)
      expect(result).to eq('Wash performed by John Q. Public in 10 minutes. Staff Code: C')
    end

    # Testing with non-existent user ID
    it 'returns user not found text for non-existent user id' do
      repair_record.update(performed_by_user_id: 99_999)
      result = helper.generate_in_house_repair_string(repair_record, nil)
      expect(result).to eq('Wash performed by User not found (ID: 99999) in 10 minutes. Other note: Please check spine. Staff Code: C')
    end
  end
end
