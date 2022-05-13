# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'staff_codes/index', type: :view do
  include Devise::Test::ControllerHelpers

  before(:each) do
    assign(:staff_codes, [
             StaffCode.create!(
               code: 'Code',
               points: 2
             ),
             StaffCode.create!(
               code: 'Code',
               points: 2
             )
           ])
  end

  it 'renders a list of staff_codes' do
    render
    assert_select 'tr>td', text: 'Code'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
  end
end
