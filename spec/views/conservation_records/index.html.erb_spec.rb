# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/index', type: :view do
  include Devise::Test::ControllerHelpers
  include Pagy::Backend

  let!(:conservation_record1) do
    create(:conservation_record,
           date_recieved_in_preservation_services: Date.new,
           department: 'Department',
           title: 'Title',
           author: 'Author',
           imprint: 'Imprint',
           call_number: 'Call Number',
           item_record_number: 'Item Record Number',
           digitization: false)
  end

  let!(:conservation_record2) do
    create(:conservation_record,
           date_recieved_in_preservation_services: Date.new,
           department: 'Department',
           title: 'Title',
           author: 'Author',
           imprint: 'Imprint',
           call_number: 'Call Number',
           item_record_number: 'Item Record Number',
           digitization: false)
  end

  it 'renders a list of conservation_records' do
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    render
    assert_select 'td', text: conservation_record1.id.to_s, count: 1
    assert_select 'td', text: conservation_record2.id.to_s, count: 1
    assert_select 'td', text: 'Title', count: 2
    assert_select 'td', text: 'Title', count: 2
    assert_select 'td', text: 'Author', count: 2
    assert_select 'td', text: 'Call Number', count: 2
    assert_select 'td', text: 'Item Record Number', count: 2
    expect(rendered).to have_link('Title')
  end

  it 'hides controls for read_only users' do
    @user = create(:user, role: 'read_only')
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    render
    expect(rendered).not_to have_button('New Conservation Record')
  end

  it 'displays a pagination widget' do
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    render
    expect(rendered).to have_text('Prev1Next')
  end
end
