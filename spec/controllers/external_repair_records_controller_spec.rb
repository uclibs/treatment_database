# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalRepairRecordsController, type: :controller do
  let(:repair_type) { create(:controlled_vocabulary) }
  let(:vendor) { create(:controlled_vocabulary) }
  let(:conservation_record) { create(:conservation_record) }

  it 'creates an external repair record' do
    repair_count = ExternalRepairRecord.all.count
    ExternalRepairRecord.create(repair_type: repair_type.id, performed_by_vendor_id: vendor.id, conservation_record: conservation_record)
    expect(repair_count).to be < ExternalRepairRecord.all.count
  end

  it 'can destroy an external repair record' do
    repair_record = ExternalRepairRecord.create(repair_type: repair_type.id, performed_by_vendor_id: vendor.id, conservation_record: conservation_record)
    repair_count = ExternalRepairRecord.all.count
    repair_record.destroy
    expect(repair_count).to be > ExternalRepairRecord.all.count
  end
end
