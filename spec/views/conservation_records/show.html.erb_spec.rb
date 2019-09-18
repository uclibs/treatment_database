# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/show', type: :view do
  before(:each) do
    @conservation_record = assign(:conservation_record, ConservationRecord.create!(
                                                          date_recieved_in_preservation_services: Date.new,
                                                          department: ControlledVocabulary.where(vocabulary: 'department', active: true).first.id,
                                                          title: 'Title',
                                                          author: 'Author',
                                                          imprint: 'Imprint',
                                                          call_number: 'Call Number',
                                                          item_record_number: 'Item Record Number',
                                                          digitization: false
                                                        ))
    @in_house_repairs = []
    @external_repairs = []

    @users = []
    @repair_types = []
    @contract_conservators = []
  end

  it 'shows the table with all metadata' do
    render
    expect(rendered).to match(/Database ID/)
    expect(rendered).to match(/Date Recieved/)
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
end
