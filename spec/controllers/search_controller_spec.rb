# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    user = create(:user, role: 'admin')
    sign_in_user(user)
    create(:conservation_record)
    create(:conservation_record, item_record_number: 'i1001')
    create(:conservation_record, item_record_number: 'notcat2817')
    create(:conservation_record, title: 'Third Title')
  end

  def sign_in_user(user)
    sign_in user
  end

  it 'can search for documents by database id' do
    get :results, params: { search: ConservationRecord.first.id }
    expect(response).to redirect_to(conservation_record_path(ConservationRecord.first.id))
  end

  it 'can search for documents by item record number' do
    get :results, params: { search: 'i1001' }
    expected_id = ConservationRecord.find_by(item_record_number: 'i1001').id
    expect(response).to redirect_to(conservation_record_path(expected_id))
  end

  it 'can search for documents by *un-cataloged* record number' do
    get :results, params: { search: 'notcat2817' }
    expected_id = ConservationRecord.find_by(item_record_number: 'notcat2817').id
    expect(response).to redirect_to(conservation_record_path(expected_id))
  end

  it 'can search for documents by title' do
    get :results, params: { search: 'Third' }
    expected_id = ConservationRecord.find_by(title: 'Third Title')
    expect(response).to redirect_to(conservation_record_path(expected_id))
  end

  it 'shows search page when more than one result' do
    create(:conservation_record, item_record_number: 'i1001')
    get :results, params: { search: 'i1001' }
    expect(response.body).to have_text('Searching for i1001')
  end

  it 'shows no results when looking up non-extant id' do
    get :results, params: { search: '9000' }
    expect(response.body).to have_text('No Results for 9000')
  end
end
