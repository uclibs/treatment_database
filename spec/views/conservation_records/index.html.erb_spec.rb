# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/index', type: :view do
  include Pagy::Backend

  before do
    create(:staff_code, code: 'C', points: 10)
    @conservation_record1 = create(:conservation_record)
    @conservation_record2 = create(:conservation_record)
    ids = [@conservation_record1.id, @conservation_record2.id]
    relation = ConservationRecord.where(id: ids)
    @pagy, @conservation_records = pagy(relation, items: 100)
  end

  it 'renders a list of conservation_records' do
    user = create(:user, role: 'admin')
    view_login_as(user)
    view_stub_authorization(user)

    render
    assert_select 'td', text: @conservation_record1.id.to_s, count: 1
    assert_select 'td', text: @conservation_record2.id.to_s, count: 1
    assert_select 'td', text: 'The Illiad', count: 2
    assert_select 'td', text: 'James Joyce', count: 2
    assert_select 'td', text: '102340', count: 2
    assert_select 'td', text: 'i3445', count: 2
    expect(rendered).to have_link('The Illiad')
    expect(rendered).to have_link('New Conservation Record')
  end

  it 'hides controls for read_only users' do
    user = create(:user, role: 'read_only')
    view_login_as(user)
    view_stub_authorization(user)
    render

    expect(rendered).not_to have_link('New Conservation Record')
  end

  it 'displays a pagination widget' do
    user = create(:user, role: 'read_only')
    view_login_as(user)
    view_stub_authorization(user)

    # Only 2 records, so the pagy widget should be disabled
    render
    expect(rendered).to have_css('nav.pagy-bootstrap.nav')
    expect(rendered).to have_css('li.page-item.prev.disabled')
    expect(rendered).to have_css('li.page-item.next.disabled')
    expect(rendered).to have_css('a[aria-label="Previous"]', text: '<')
    expect(rendered).to have_css('a[aria-label="Next"]', text: '>')
  end
end
