# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaffCode, type: :model do
  it 'is valid with valid attributes' do
    expect(StaffCode.new(points: 2, code: 'S')).to be_valid
  end

  it 'is not valid without attributes' do
    expect(StaffCode.new).to_not be_valid
  end

  it 'is not valid without a code value' do
    expect(StaffCode.new(points: 2)).to_not be_valid
  end

  it 'is not valid without a points value' do
    expect(StaffCode.new(code: 'S')).to_not be_valid
  end
  it 'is not valid without an integer points value' do
    expect(StaffCode.new(code: 'S', points: '5.1')).to_not be_valid
    expect(StaffCode.new(code: 'S', points: 'W')).to_not be_valid
  end
end
