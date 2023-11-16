# frozen_string_literal: true

require 'rails_helper'
require 'pagy'

RSpec.describe 'conservation_records/conservation_worksheet', type: :view do
  before(:each) do
    department_id = ControlledVocabulary.find_by(vocabulary: 'department', key: 'Engineering Library').id
    assign(:conservation_record, create(:conservation_record, department: department_id))
  end

  it 'renders new conservation_record form' do
    render

    expect(rendered).to have_content('Engineering Library')
    expect(rendered).to have_content('The Illiad')
    expect(rendered).to have_content('James Joyce')
    expect(rendered).to have_content('Dutton')
    expect(rendered).to have_content('i3445')
    expect(rendered).to have_content('102340')
  end
end
