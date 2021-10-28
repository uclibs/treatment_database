# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'reports/index', type: :view, js: true do
  before do
    @q = CostReturnReport.none.ransack
    @results = []
    render
  end

  it 'renders header' do
    expect(rendered).to have_text('Reports')
  end

  it 'renders search form' do
    expect(rendered).to have_unchecked_field('q_complete_eq')
    expect(rendered).to have_unchecked_field('q_in_house_repair_records_id_null')
  end

  it 'shows the table with all metadata' do
    expect(rendered).to match(/Database ID/)
    expect(rendered).to match(/Department/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Item Record#/)
    expect(rendered).to match(/In-House Repairs?/)
  end
end
