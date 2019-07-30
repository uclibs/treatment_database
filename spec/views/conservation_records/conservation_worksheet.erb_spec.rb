# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/conservation_worksheet', type: :view do
  before(:each) do
    assign(:conservation_record, create(:conservation_record))
  end

  it 'renders new conservation_record form' do
    render

    expect(rendered).to have_content('Department A')
    expect(rendered).to have_content('The Illiad')
    expect(rendered).to have_content('James Joyce')
    expect(rendered).to have_content('Dutton')
    expect(rendered).to have_content('ir3445')
    expect(rendered).to have_content('102340')
  end
end
