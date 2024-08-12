# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'front/index.html.erb', type: :view do
  before do
    render
  end

  it 'has a welcome text' do
    expect(rendered).to have_text('Treatment Database')
    expect(rendered).to have_text('Track objects through various stages of the treatment process.')
  end
end
