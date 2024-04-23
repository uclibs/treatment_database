# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/index', type: :view do
  include Devise::Test::ControllerHelpers
  include Pagy::Backend
  before do
    StaffCode.create(code: 'C', points: 10)
    @conservation_record1 = ConservationRecord.create(
      date_received_in_preservation_services: Date.new,
      department: 'Department',
      title: 'Title',
      author: 'Author',
      imprint: 'Imprint',
      call_number: 'Call Number',
      item_record_number: 'Item Record Number',
      digitization: false
    )
    @conservation_record2 = ConservationRecord.create(
      date_received_in_preservation_services: Date.new,
      department: 'Department',
      title: 'Title',
      author: 'Author',
      imprint: 'Imprint',
      call_number: 'Call Number',
      item_record_number: 'Item Record Number',
      digitization: false
    )
    ids = [@conservation_record1.id, @conservation_record2.id]
    relation = ConservationRecord.where(id: ids)
    @pagy, @conservation_records = pagy(relation, items: 100)
  end

  it 'renders a list of conservation_records' do
    render
    assert_select 'td', text: @conservation_record1.id.to_s, count: 1
    assert_select 'td', text: @conservation_record2.id.to_s, count: 1
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
    render
    expect(rendered).not_to have_button('New Conservation Record')
  end

  it 'displays a pagination widget' do
    # Only 2 records, so the pagy widget should be disabled
    render
    expect(rendered).to have_css('nav.pagy-bootstrap-nav')
    expect(rendered).to have_css('li.page-item.prev.disabled')
    expect(rendered).to have_css('li.page-item.next.disabled')
    expect(rendered).to have_css('a[aria-label="Previous"]', text: '<')
    expect(rendered).to have_css('a[aria-label="Next"]', text: '>')
  end

end
