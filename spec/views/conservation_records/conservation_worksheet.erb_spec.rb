# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/conservation_worksheet', type: :view do
  before(:each) do
    assign(:conservation_record, create(:conservation_record))
  end

  it 'renders new conservation_record form' do
    render

    expect(rendered).to have_content('Department A')
    expect(rendered).to have_content('A Farewell to Arms')
    expect(rendered).to have_content('Ernest Hemmingway')
    expect(rendered).to have_content('Scribner')
    expect(rendered).to have_content('1234')
    expect(rendered).to have_content('5678')
  end
end
