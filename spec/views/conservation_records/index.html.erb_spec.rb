# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/index', type: :view do
  include Devise::Test::ControllerHelpers
  include Pagy::Backend

  before do
    StaffCode.create(code: 'C', points: 10)

    @conservation_record1 = ConservationRecord.create!(
      date_received_in_preservation_services: Date.new,
      department: 'Department',
      title: 'Title',
      author: 'Author',
      imprint: 'Imprint',
      call_number: 'Call Number',
      item_record_number: 'Item Record Number',
      digitization: false
    )
    @conservation_record2 = ConservationRecord.create!(
      date_received_in_preservation_services: Date.new,
      department: 'Department',
      title: 'Title',
      author: 'Author',
      imprint: 'Imprint',
      call_number: 'Call Number',
      item_record_number: 'Item Record Number',
      digitization: false
    )
    assign(:conservation_records, [@conservation_record1, @conservation_record2])
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    render
  end

  it 'renders a list of conservation_records' do
    expect(rendered).to have_selector('td', text: @conservation_record1.id.to_s, count: 1)
    expect(rendered).to have_selector('td', text: @conservation_record2.id.to_s, count: 1)
    expect(rendered).to have_selector('td', text: 'Title', count: 2)
    expect(rendered).to have_selector('td', text: 'Author', count: 2)
    expect(rendered).to have_selector('td', text: 'Call Number', count: 2)
    expect(rendered).to have_selector('td', text: 'Item Record Number', count: 2)
    expect(rendered).to have_link('Title')
  end

  it 'hides controls for read_only users' do
    @user = create(:user, role: 'read_only')
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    expect(rendered).not_to have_button('New Conservation Record')
  end

  it 'displays a pagination widget' do
    expect(rendered).to match(/>\s*1\s*</)
  end
end
