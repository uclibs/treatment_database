# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConservationRecordsHelper, type: :helper do
  let!(:user) { create(:user) }
  let!(:conservation_record) { create(:conservation_record) }
  let!(:cost_report) { create :cost_return_report, conservation_record: conservation_record }

  it 'formats date_returned value' do
    cost_report.returned_to_origin = '2020-04-22 17:34:48'
    return_value = helper.date_returned(conservation_record)
    expect(return_value).to eq('2020-04-22 17:34:48'.to_date)
  end
end
