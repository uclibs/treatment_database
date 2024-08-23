# frozen_string_literal: true

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe AbbreviatedTreatmentReport, type: :model do
  let(:conservation_record) { create(:conservation_record) }
  let(:abbreviated_treatment_report) { build(:abbreviated_treatment_report, conservation_record:) }

  describe 'associations' do
    it 'belongs to a conservation record' do
      expect(abbreviated_treatment_report).to belong_to(:conservation_record)
    end
  end

  describe 'validations' do
    it 'is valid with a conservation record' do
      expect(abbreviated_treatment_report).to be_valid
    end

    it 'is invalid without a conservation record' do
      abbreviated_treatment_report.conservation_record = nil
      expect(abbreviated_treatment_report).not_to be_valid
    end
  end
end
