# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ActivityHelper. For example:
#
# describe ActivityHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ActivityHelper, type: :helper do
  let!(:version) { PaperTrail::Version.create }
  describe 'version_summarizer' do
    it 'summarizes the version' do
      return_name = helper.version_summarizer(version)
      expect(return_name).to eq('Someone did something to the some item: ')
    end
  end

  describe 'event_to_summary' do
    context 'when the event is update' do
      before do
        allow(version).to receive('event').and_return('update') # This stubs version.event to be "update"
      end

      it 'defines event as update' do
        return_value = helper.event_to_summary(version.event)
        expect(return_value).to eq('updated')
      end
    end

    context 'when the event is create' do
      before do
        allow(version).to receive('event').and_return('create') # This stubs version.event to be "update"
      end

      it 'defines event as create' do
        return_value = helper.event_to_summary(version.event)
        expect(return_value).to eq('created')
      end
    end

    context 'when the event is destroy' do
      before do
        allow(version).to receive('event').and_return('destroy') # This stubs version.event to be "update"
      end

      it 'defines event as update' do
        return_value = helper.event_to_summary(version.event)
        expect(return_value).to eq('deleted')
      end
    end

    context 'when the event is something else' do
      before do
        allow(version).to receive('event').and_return('else') # This stubs version.event to be "update"
      end
      it 'defines event as else' do
        return_value = helper.event_to_summary(version.event)
        expect(return_value).to eq('did something to')
      end
    end
  end

  describe 'item_type_to_summary' do
    context 'when item_type is ConservationRecord' do
      before do
        allow(version).to receive('item_type').and_return('ConservationRecord')
      end

      it 'defines item_type as conservation record' do
        return_value = helper.item_type_to_summary(version.item_type)
        expect(return_value).to eq('conservation record')
      end
    end

    context 'when item_type is TreatmentReport' do
      before do
        allow(version).to receive('item_type').and_return('TreatmentReport')
      end

      it 'defines item_type as treatment report' do
        return_value = helper.item_type_to_summary(version.item_type)
        expect(return_value).to eq('treatment report')
      end
    end

    context 'when item_type is InHouseRepairRecord' do
      before do
        allow(version).to receive('item_type').and_return('InHouseRepairRecord')
      end

      it 'defines item_type as in house repair record' do
        return_value = helper.item_type_to_summary(version.item_type)
        expect(return_value).to eq('in house repair record')
      end
    end

    context 'when item_type is ExternalRepairRecord' do
      before do
        allow(version).to receive('item_type').and_return('ExternalRepairRecord')
      end

      it 'defines item_type as external repair record' do
        return_value = helper.item_type_to_summary(version.item_type)
        expect(return_value).to eq('external repair record')
      end
    end

    context 'when item_type is CostReturnReport' do
      before do
        allow(version).to receive('item_type').and_return('CostReturnReport')
      end

      it 'defines item_type as cost return report' do
        return_value = helper.item_type_to_summary(version.item_type)
        expect(return_value).to eq('cost return report')
      end
    end
  end

  describe 'name_to_summary' do
    context 'when item_type is ConservationRecord and the record exists' do
      let!(:conservation_record) do
        ConservationRecord.create(date_received_in_preservation_services: '2021-01-19',
                                  title: 'This is a Test',
                                  author: 'F. Scott Fitzgerald',
                                  imprint: 'Scribner',
                                  call_number: 'PS3511.I9 G7 2004',
                                  item_record_number: 'i58811074',
                                  digitization: true,
                                  department: 1502)
      end
      before do
        allow(version).to receive('item_id').and_return(conservation_record.id)
        allow(version).to receive('item_type').and_return('ConservationRecord')
      end
      it 'defines item_type as conservation record' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq("<a href=\"/conservation_records/#{conservation_record.id}\">This is a Test</a>")
      end
    end
    context 'when item_type is ConservationRecord and the record does not exist' do
      before do
        allow(version).to receive('item_type').and_return('ConservationRecord')
        allow(version).to receive('object').and_return('test\ntitle: This is a Test')
      end
      it 'defines item_type as conservation record' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq('This is a Test')
      end
    end

    context 'when item_type is TreatmentReport and the record exists' do
      let!(:conservation_record) do
        ConservationRecord.create(date_received_in_preservation_services: '2021-01-19',
                                  title: 'This is a Test',
                                  author: 'F. Scott Fitzgerald',
                                  imprint: 'Scribner',
                                  call_number: 'PS3511.I9 G7 2004',
                                  item_record_number: 'i58811074',
                                  digitization: true,
                                  department: 1502)
      end

      let!(:treatment_report) do
        TreatmentReport.create(conservation_record_id: conservation_record.id,
                               description_general_remarks: 'Good',
                               description_binding: nil,
                               description_textblock: nil,
                               description_primary_support: nil,
                               description_medium: nil,
                               description_attachments_inserts: nil,
                               description_housing: nil,
                               condition_summary: nil,
                               condition_binding: nil,
                               condition_textblock: nil,
                               condition_primary_support: nil,
                               condition_medium: nil,
                               condition_housing_id: nil,
                               condition_housing_narrative: nil,
                               condition_attachments_inserts: nil,
                               condition_previous_treatment: nil,
                               condition_materials_analysis: nil,
                               treatment_proposal_proposal: nil,
                               treatment_proposal_housing_need_id: nil,
                               treatment_proposal_factors_influencing_treatment: nil,
                               treatment_proposal_performed_treatment: nil,
                               treatment_proposal_housing_provided_id: nil,
                               treatment_proposal_housing_narrative: nil,
                               treatment_proposal_storage_and_handling_notes: nil,
                               treatment_proposal_total_treatment_time: nil,
                               created_at: '2021-01-21 19:29:04',
                               updated_at: '2021-01-21 19:29:04',
                               conservators_note: nil)
      end

      before do
        allow(version).to receive('item_id').and_return(treatment_report.id)
        allow(version).to receive('item_type').and_return('TreatmentReport')
      end
      it 'defines item_type as treatment report' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq("<a href=\"/conservation_records/#{TreatmentReport.find(treatment_report.id).conservation_record.id}\">This is a Test</a>")
      end
    end
    context 'when item_type is TreatmentReport and the record does not exist' do
      before do
        allow(version).to receive('item_type').and_return('TreatmentReport')
        allow(version).to receive('object').and_return('Record has been deleted')
      end
      it 'defines item_type as treatment report' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq('Record has been deleted')
      end
    end

    context 'when item_type is InHouseRepairRecord and the record exists' do
      let!(:conservation_record) do
        ConservationRecord.create(date_received_in_preservation_services: '2021-01-19',
                                  title: 'This is a Test',
                                  author: 'F. Scott Fitzgerald',
                                  imprint: 'Scribner',
                                  call_number: 'PS3511.I9 G7 2004',
                                  item_record_number: 'i58811074',
                                  digitization: true,
                                  department: 1502)
      end

      let!(:in_house_repair_record) do
        InHouseRepairRecord.create(repair_type: 2,
                                   performed_by_user_id: 1,
                                   minutes_spent: nil,
                                   conservation_record_id: conservation_record.id,
                                   created_at: '2021-01-26 15:36:59',
                                   updated_at: '2021-01-26 15:36:59')
      end

      before do
        allow(version).to receive('item_id').and_return(in_house_repair_record.id)
        allow(version).to receive('item_type').and_return('InHouseRepairRecord')
      end
      it 'defines item_type as in house repair record' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq("<a href=\"/conservation_records/#{InHouseRepairRecord.find(in_house_repair_record.id).conservation_record.id}\">This is a Test</a>")
      end
    end

    context 'when item_type is InHouseRepairRecord and the record does not exist' do
      before do
        allow(version).to receive('item_type').and_return('InHouseRepairRecord')
        allow(version).to receive('object').and_return('Record has been deleted')
      end
      it 'defines item_type as in house repair record' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq('Record has been deleted')
      end
    end

    context 'when item_type is ExternalRepairRecord and the record exists' do
      let!(:conservation_record) do
        ConservationRecord.create(date_received_in_preservation_services: '2021-01-19',
                                  title: 'This is a Test',
                                  author: 'F. Scott Fitzgerald',
                                  imprint: 'Scribner',
                                  call_number: 'PS3511.I9 G7 2004',
                                  item_record_number: 'i58811074',
                                  digitization: true,
                                  department: 1502)
      end

      let!(:external_repair_record) do
        ExternalRepairRecord.create(repair_type: 2,
                                    performed_by_vendor_id: 1,
                                    conservation_record_id: conservation_record.id,
                                    created_at: '2021-01-26 15:36:59',
                                    updated_at: '2021-01-26 15:36:59')
      end

      before do
        allow(version).to receive('item_id').and_return(external_repair_record.id)
        allow(version).to receive('item_type').and_return('ExternalRepairRecord')
      end
      it 'defines item_type as external repair record' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq("<a href=\"/conservation_records/#{ExternalRepairRecord.find(external_repair_record.id).conservation_record.id}\">This is a Test</a>")
      end
    end

    context 'when item_type is ExternalRepairRecord and the record does not exist' do
      before do
        allow(version).to receive('item_type').and_return('ExternalRepairRecord')
        allow(version).to receive('object').and_return('Record has been deleted')
      end
      it 'defines item_type as external repair record' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq('Record has been deleted')
      end
    end

    context 'when item_type is CostReturnReport and the record exists' do
      let!(:conservation_record) do
        ConservationRecord.create(date_received_in_preservation_services: '2021-01-19',
                                  title: 'This is a Test',
                                  author: 'F. Scott Fitzgerald',
                                  imprint: 'Scribner',
                                  call_number: 'PS3511.I9 G7 2004',
                                  item_record_number: 'i58811074',
                                  digitization: true,
                                  department: 1502)
      end

      let!(:cost_return_report) do
        CostReturnReport.create(shipping_cost: nil,
                                repair_estimate: nil,
                                repair_cost: nil,
                                invoice_sent_to_business_office: nil,
                                complete: nil,
                                returned_to_origin: nil,
                                note: nil,
                                conservation_record_id: conservation_record.id,
                                created_at: '2021-01-08 16:20:18',
                                updated_at: '2021-01-08 16:20:18')
      end

      before do
        allow(version).to receive('item_id').and_return(cost_return_report.id)
        allow(version).to receive('item_type').and_return('CostReturnReport')
      end
      it 'defines item_type as cost return report' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq("<a href=\"/conservation_records/#{CostReturnReport.find(cost_return_report.id).conservation_record.id}\">This is a Test</a>")
      end
    end
    context 'when item_type is CostReturnReport and the record does not exist' do
      before do
        allow(version).to receive('item_type').and_return('CostReturnReport')
        allow(version).to receive('object').and_return('Record has been deleted')
      end
      it 'defines item_type as cost return report' do
        return_value = helper.name_to_summary(version)
        expect(return_value).to eq('Record has been deleted')
      end
    end
  end
end
