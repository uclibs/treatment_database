# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'reports/index', type: :view, js: true do
  before do
    render
  end

  it 'renders header' do
    expect(rendered).to have_text('Reports')
  end

  it 'has new report button' do
    expect(rendered).to have_link('New Report')
  end

  it 'shows the table with all metadata' do
    expect(rendered).to match(/Date Created/)
    expect(rendered).to match(/File/)
  end
end
