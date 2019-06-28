# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/index', type: :view do
  before(:each) do
    assign(:conservation_records, [
             ConservationRecord.create!(
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

  it 'renders a list of conservation_records' do
    render
    assert_select 'td', text: 'Title', count: 2
    assert_select 'td', text: 'Title', count: 2
    assert_select 'td', text: 'Author', count: 2
    assert_select 'td', text: 'Call Number', count: 2
    assert_select 'td', text: 'Item Record Number', count: 2
  end
end
