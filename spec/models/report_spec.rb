# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  today = Time.zone.today

  it 'is valid when all required params are provided' do
    report = Report.new(start_date: today, end_date: today)
    expect(report).to be_valid
  end

  it 'is not valid with required params' do
    report = Report.new
    expect(report).to_not be_valid
  end

  it 'is not valid without start date' do
    report = Report.new(end_date: today)
    expect(report).to_not be_valid
  end

  it 'is not valid without end date' do
    report = Report.new(start_date: today)
    expect(report).to_not be_valid
  end
end
