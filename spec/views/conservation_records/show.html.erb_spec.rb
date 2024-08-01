# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/show', type: :view do

  before(:each) do
    # @conservation_record = assign(:conservation_record, ConservationRecord.create!(
    #                                                       date_received_in_preservation_services: Date.new,
    #                                                       department: ControlledVocabulary.where(vocabulary: 'department', active: true).first.id,
    #                                                       title: 'Title',
    #                                                       author: 'Author',
    #                                                       imprint: 'Imprint',
    #                                                       call_number: 'Call Number',
    #                                                       item_record_number: 'Item Record Number',
    #                                                       digitization: false,
    #                                                       treatment_report: TreatmentReport.create,
    #                                                       abbreviated_treatment_report: AbbreviatedTreatmentReport.create,
    #                                                       cost_return_report: CostReturnReport.create
    #                                                     ))
    @conservation_record = create(:conservation_record)
    @in_house_repairs = []
    @external_repairs = []
    @con_tech_records = []
    @housing = []
    @users = []
    @repair_types = []
    @contract_conservators = []
    @staff_codes = []
  end

  it 'shows the table with all metadata' do
    render
    expect(rendered).to match(/Database ID/)
    expect(rendered).to match(/Date Received/)
    expect(rendered).to match(/Department/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Author/)
    expect(rendered).to match(/Imprint/)
    expect(rendered).to match(/Call Number/)
    expect(rendered).to match(/Item Record Number/)
    expect(rendered).to match(/Is Digitized?/)
  end

  it 'has a link to download the conservation worksheet' do
    render
    expect(rendered).to have_link('Download Conservation Worksheet')
  end

  it 'hides controls for read_only users' do
    @user = create(:user, role: 'read_only')
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    render
    expect(rendered).not_to have_link('Edit Conservation Record')
    expect(rendered).not_to have_button('Add In-House Repairs')
    expect(rendered).not_to have_button('Add External Repair')
    expect(rendered).not_to have_button('Add Conservators and Technicians')
    expect(rendered).not_to have_button('Delete In-House Repair')
    expect(rendered).not_to have_button('Delete External Repair')
    expect(rendered).not_to have_button('Delete Conservators and Technicians')
  end
end
