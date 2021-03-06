# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InHouseRepairRecordsHelper, type: :helper do
  let(:conservation_record) { create(:conservation_record) }
  let(:repair_type) { create(:controlled_vocabulary, vocabulary: 'repair_type', key: 'Wash') }
  let(:user) { create(:user, display_name: 'John Q. Public') }
  let(:repair_record) do
    create(:in_house_repair_record,
           performed_by_user_id: user.id,
           repair_type: repair_type.id,
           conservation_record:
           conservation_record)
  end
  it 'generates an in house repair string' do
    expect(helper.generate_in_house_repair_string(repair_record, 0)).to eq('1. Wash performed by John Q. Public in 10 minutes.')
  end
end
