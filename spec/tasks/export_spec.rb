# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'export.rake', type: :task do
  let(:rake_task) { Rake::Task['export:all_data'] }
  let(:cost_return_report) { FactoryBot.create(:cost_return_report) }
  let(:in_house_repair_record) { FactoryBot.create(:in_house_repair_record) }
  let(:external_repair_record) { FactoryBot.create(:external_repair_record) }
  let(:treatment_report) { FactoryBot.create(:treatment_report) }
  let(:con_tech_record) { FactoryBot.create(:con_tech_record) }
  before do
    cost_return_report
    in_house_repair_record
    external_repair_record
    treatment_report
    con_tech_record
  end
  context 'when executing the all_data export task' do
    it 'generates headings corresponding to existing records' do
      expect { rake_task.execute }.to change { Report.count }.by(1)
    end
  end
end