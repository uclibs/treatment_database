# frozen_string_literal: true

require 'rails_helper'

TreatmentDatabase::Application.load_tasks if Rake::Task.tasks.empty?
describe 'export.rake' do
  let!(:user) { create(:user) }
  let!(:conservation_record) { create(:conservation_record) }
  let!(:staff_code) { create(:staff_code) }
  let!(:repair_type) { create(:controlled_vocabulary, key: 'repair_type', vocabulary: 'tape', active: true) }
  let!(:vendor) { create(:controlled_vocabulary, key: 'vendor', vocabulary: 'Home depot', active: true) }
  let!(:cost_return_report) { create(:cost_return_report, conservation_record_id: conservation_record.id) }
  let!(:in_house_repair_record) do
    create(:in_house_repair_record, conservation_record_id: conservation_record.id, staff_code_id: staff_code.id, performed_by_user_id: user.id,
                                    repair_type: repair_type.id)
  end
  let!(:external_repair_record) do
    create(:external_repair_record, conservation_record_id: conservation_record.id, performed_by_vendor_id: vendor.id, repair_type: repair_type.id)
  end
  let!(:treatment_report) { create(:treatment_report, conservation_record_id: conservation_record.id) }
  let!(:con_tech_record) { create(:con_tech_record, conservation_record_id: conservation_record.id, performed_by_user_id: user.id) }

  let(:rake_task) { Rake::Task['export:all_data'].execute }

  it 'generates headings corresponding to existing records' do
    expect { rake_task }.to change { Report.count }.by(1)
  end
end
