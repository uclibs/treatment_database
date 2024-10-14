# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalRepairRecordsHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:repair_type) { create(:controlled_vocabulary, vocabulary: 'repair_type', key: 'Wash') }
  let!(:vendor) { create(:controlled_vocabulary, vocabulary: 'contract_conservator', key: 'John Q. Public') }

  let!(:external_repair_record) do
    create(:external_repair_record, repair_type: repair_type.id, performed_by_vendor_id: vendor.id, other_note: 'Prepared for etc')
  end

  let!(:external_repair_record_no_note) do
    create(:external_repair_record, repair_type: repair_type.id, performed_by_vendor_id: vendor.id, other_note: nil)
  end

  describe '#generate_external_repair_string' do
    it 'generates an external repair string with index and other_note present' do
      return_value = helper.generate_external_repair_string(external_repair_record, 0)
      expect(return_value).to eq('1. Wash performed by John Q. Public. Other note: Prepared for etc')
    end

    it 'generates an external repair string with no index and other_note present' do
      return_value = helper.generate_external_repair_string(external_repair_record, nil)
      expect(return_value).to eq('Wash performed by John Q. Public. Other note: Prepared for etc')
    end

    it 'generates an external repair string with index and no other_note present' do
      return_value = helper.generate_external_repair_string(external_repair_record_no_note, 1)
      expect(return_value.strip).to eq('2. Wash performed by John Q. Public.')
    end

    it 'generates an external repair string with no index and no other_note present' do
      return_value = helper.generate_external_repair_string(external_repair_record_no_note, nil)
      expect(return_value.strip).to eq('Wash performed by John Q. Public.')
    end

    it 'generates an external repair string with missing repair_type' do
      external_repair_record.update(repair_type: nil)
      return_value = helper.generate_external_repair_string(external_repair_record, 0)
      expect(return_value).to eq('1. ID Missing performed by John Q. Public. Other note: Prepared for etc')
    end
  end
end
