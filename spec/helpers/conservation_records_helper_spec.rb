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

  describe 'friendly_housing' do
    context 'defines id as nil' do
      it 'returns "No Housing method Selected"' do
        return_value = helper.friendly_housing(nil)
        expect(return_value).to eq('No housing method selected.')
      end
    end

    context 'defines id as not nil' do
      let!(:controlled_vocabulary) do
        ControlledVocabulary.create(vocabulary: 'repair_type',
                                    key: 'Repair/restore binding',
                                    active: true,
                                    created_at: '2021-01-06 22:59:40',
                                    updated_at: '2021-01-06 22:59:40')
      end
      it 'return Controlled Vocabulary object' do
        return_value = helper.friendly_housing(controlled_vocabulary.id)
        expect(return_value.key).to eq('Repair/restore binding')
      end
    end
  end
end
