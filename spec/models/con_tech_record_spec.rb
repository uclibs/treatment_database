# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConTechRecord, type: :model do
  before(:each) do
    @conservation_record = create(:conservation_record)
  end

  it 'is valid with valid attributes' do
    expect(ConTechRecord.new(performed_by_user_id: 2, conservation_record_id: @conservation_record.id)).to be_valid
  end

  it 'is not valid without attributes' do
    expect(ConTechRecord.new).to_not be_valid
  end

  it 'is not valid without a performed by user id value' do
    expect(ConTechRecord.new(conservation_record_id: @conservation_record.id)).to_not be_valid
  end

  it 'is not valid without a conservation record id' do
    expect(ConTechRecord.new(performed_by_user_id: 2)).to_not be_valid
  end
end
