# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConservationRecord, type: :model do
  it 'is not valid without attributes' do
    expect(ConservationRecord.new).to_not be_valid
  end

  it 'is valid with valid attributes' do
    expect(ConservationRecord.new(department: '1', title: 'Some test title', author: 'Earnest Hemingway', imprint: 'Uc Press', call_number: 'PA2323',
                                  item_record_number: 'i33322222')).to be_valid
  end

  it 'is not valid without department attribute' do
    expect(ConservationRecord.new(title: 'Some test title', author: 'Earnest Hemingway', imprint: 'Uc Press', call_number: 'PA2323',
                                  item_record_number: 'i33322222')).to_not be_valid
  end

  it 'is not valid without title attribute' do
    expect(ConservationRecord.new(department: '1', author: 'Earnest Hemingway', imprint: 'Uc Press', call_number: 'PA2323',
                                  item_record_number: 'i33322222')).to_not be_valid
  end

  it 'is not valid without author attribute' do
    expect(ConservationRecord.new(department: '1', title: 'Some test title', imprint: 'Uc Press', call_number: 'PA2323',
                                  item_record_number: 'i33322222')).to_not be_valid
  end

  it 'is valid without imprint attribute' do
    expect(ConservationRecord.new(department: '1', title: 'Some test title', author: 'Earnest Hemingway', call_number: 'PA2323',
                                  item_record_number: 'i33322222')).to_not be_valid
  end

  it 'is valid without call_number attribute' do
    expect(ConservationRecord.new(department: '1', title: 'Some test title', author: 'Earnest Hemingway', imprint: 'Uc Press',
                                  item_record_number: 'i33322222')).to_not be_valid
  end

  it 'is valid with item_record attribute' do
    expect(ConservationRecord.new(department: '1', title: 'Some test title', author: 'Earnest Hemingway', imprint: 'Uc Press',
                                  call_number: 'PA2323')).to_not be_valid
  end
end
