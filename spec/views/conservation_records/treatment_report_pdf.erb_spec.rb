# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/treatment_report_pdf', type: :view do
  before(:each) do
    department_id = ControlledVocabulary.find_by(vocabulary: 'department', key: 'Engineering Library').id
    assign(:conservation_record, create(:conservation_record, department: department_id))
    conservation_record_id = ConservationRecord.last.id
    assign(:treatment_report, create(:treatment_report, conservation_record_id: conservation_record_id))
  end

  it 'renders new treatment_report_pdf form' do
    render

    expect(rendered).to have_content('Engineering Library')
    expect(rendered).to have_content('The Illiad')
    expect(rendered).to have_content('James Joyce')
    expect(rendered).to have_content('i3445')
    expect(rendered).to have_content('102340')
    headers = ['DESCRIPTION', 'CONDITION', 'TREATMENT', 'PRODUCTION - WORK ASSIGNMENT AND TIME', 'TOTAL Treatment and Documentation Time']
    headers.each do |header|
      expect(rendered).to have_content(header)
    end
  end
end
