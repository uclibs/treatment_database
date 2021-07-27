# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    user = create(:user, role: 'admin')
    sign_in(user)
  end

  let!(:conservation_record) { create(:conservation_record_with_cost_return_report) }

  it 'returns no results with blank search' do
    get :index, params: { q: {} }
    expect(response.body).to have_text('No Results')
  end

  it 'returns completed results within date parameters' do
    get :index, params: { q: { complete_eq: true } }
    expect(response.body).to have_text(conservation_record.title)
  end
end
