# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InHouseRepairRecord, type: :model do
  before(:each) do
    @conservation_record = create(:conservation_record)
    @staff_code = create(:staff_code)
  end

  it 'is valid with valid attributes' do
    expect(InHouseRepairRecord.new(conservation_record_id: @conservation_record.id, staff_code_id: @staff_code.id, performed_by_user_id: 2,
                                   minutes_spent: 23, repair_type: '1')).to be_valid
  end

  it 'is not valid without attributes' do
    expect(InHouseRepairRecord.new).to_not be_valid
  end

  it 'is not valid without a performed_by_user id value' do
    expect(InHouseRepairRecord.new(conservation_record_id: @conservation_record.id, staff_code_id: @staff_code.id, minutes_spent: 23,
                                   repair_type: '1')).to_not be_valid
  end

  it 'is not valid without a repair_type value' do
    expect(InHouseRepairRecord.new(conservation_record_id: @conservation_record.id, staff_code_id: @staff_code.id, performed_by_user_id: 2,
                                   minutes_spent: 12)).to_not be_valid
  end

  it 'is not valid without a minutes spent value' do
    expect(InHouseRepairRecord.new(conservation_record_id: @conservation_record.id, staff_code_id: @staff_code.id, performed_by_user_id: 2,
                                   repair_type: 1)).to_not be_valid
  end

  it 'is not valid without a staff_code id' do
    expect(InHouseRepairRecord.new(conservation_record_id: @conservation_record.id, performed_by_user_id: 2, repair_type: 1)).to_not be_valid
  end
end
