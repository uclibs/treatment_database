# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalRepairRecord, type: :model do
  it 'is valid with valid attributes' do
    @conservation_record = create(:conservation_record)
    expect(ExternalRepairRecord.new(conservation_record_id: @conservation_record.id, performed_by_vendor_id: 2, repair_type: '1')).to be_valid
  end

  it 'is not valid without attributes' do
    expect(ExternalRepairRecord.new).to_not be_valid
  end

  it 'is not valid without a performed_by_vendor_id value' do
    @conservation_record = create(:conservation_record)
    expect(ExternalRepairRecord.new(conservation_record_id: @conservation_record.id, repair_type: '1')).to_not be_valid
  end

  it 'is not valid without a repair_type value' do
    @conservation_record = create(:conservation_record)
    expect(ExternalRepairRecord.new(conservation_record_id: @conservation_record.id, performed_by_vendor_id: 2)).to_not be_valid
    expect(ExternalRepairRecord.new(performed_by_vendor_id: '1')).to_not be_valid
  end
end
