# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/index', type: :view do
  include Devise::Test::ControllerHelpers
  include Pagy::Backend

  before(:each) do
    assign(:conservation_records, [
             ConservationRecord.create!(
               id: 101,
               date_recieved_in_preservation_services: Date.new,
               department: 'Department',
               title: 'Title',
               author: 'Author',
               imprint: 'Imprint',
               call_number: 'Call Number',
               item_record_number: 'Item Record Number',
               digitization: false
             ),
             ConservationRecord.create!(
               id: 102,
               date_recieved_in_preservation_services: Date.new,
               department: 'Department',
               title: 'Title',
               author: 'Author',
               imprint: 'Imprint',
               call_number: 'Call Number',
               item_record_number: 'Item Record Number',
               digitization: false
             )
           ])
  end

  after(:all) do
    ConservationRecord.all.delete_all
  end

  it 'renders a list of conservation_records' do
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    render
    assert_select 'td', text: '101', count: 1
    assert_select 'td', text: '102', count: 1
    assert_select 'td', text: 'Title', count: 2
    assert_select 'td', text: 'Title', count: 2
    assert_select 'td', text: 'Author', count: 2
    assert_select 'td', text: 'Call Number', count: 2
    assert_select 'td', text: 'Item Record Number', count: 2
  end

  it 'hides controls for read_only users' do
    @user = create(:user, role: 'read_only')
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    render
    expect(rendered).not_to have_link('New Conservation Record')
    expect(rendered).not_to have_link('Edit')
    expect(rendered).not_to have_link('Destroy')
  end

  it 'displays a pagination widget' do
    @pagy, @conservation_records = pagy(ConservationRecord.all, items: 100)
    render
    expect(rendered).to have_text('Prev1Next')
  end
end
