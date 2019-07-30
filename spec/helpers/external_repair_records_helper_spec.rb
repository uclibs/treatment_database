# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ExternalRecordsHelper. For example:
#
# describe ExternalRecordsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ExternalRepairRecordsHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:repair_type) { create(:controlled_vocabulary, vocabulary: 'repair_type', key: 'Wash') }
  let!(:vendor) { create(:controlled_vocabulary, vocabulary: 'contract_conservator', key: 'John Q. Public') }
  let!(:external_repair_record) { create(:external_repair_record, repair_type: repair_type.id, performed_by_vendor_id: vendor.id) }
  it 'generates an external repair string' do
    return_value = helper.generate_external_repair_string(external_repair_record)
    expect(return_value).to eq('Wash performed by John Q. Public.')
  end
end
