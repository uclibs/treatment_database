# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AbbreviatedTreatmentReportHelper. For example:
#
# describe AbbreviatedTreatmentReportHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AbbreviatedTreatmentReportHelper, type: :helper do
  let(:conservation_record) { create(:conservation_record) }
  let(:repair_type) { create(:controlled_vocabulary, vocabulary: 'repair_type', key: 'Repair/restore binding') }
  let(:user) { create(:user, display_name: 'Haritha Vytla') }
  let(:repair_record) do
    create(:in_house_repair_record,
           performed_by_user_id: user.id,
           repair_type: repair_type.id,
           conservation_record: conservation_record,
           minutes_spent: 2)
  end

  describe 'generate_abbreviated_treatment_report_type' do
    it 'returns "Repair Type"' do
      return_value = helper.generate_abbreviated_treatment_report_type(repair_record, 1)
      expect(return_value).to eq('Repair/restore binding')
    end
  end

  describe 'generate_abbreviated_treatment_report_performed_by' do
    it 'returns the "User ID"' do
      return_value = helper.generate_abbreviated_treatment_report_performed_by(repair_record, 1)
      expect(return_value).to eq('Haritha Vytla')
    end
  end

  describe 'generate_abbreviated_treatment_report_time' do
    it 'returns "minutes spent on In House Repair Record"' do
      return_value = helper.generate_abbreviated_treatment_report_time(repair_record, 1)
      expect(return_value).to eq('2')
    end
  end
end
