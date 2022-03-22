# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'staff_codes/new', type: :view do
  before(:each) do
    assign(:staff_code, StaffCode.new(
                          code: 'MyString',
                          points: 1
                        ))
  end

  it 'renders new staff_code form' do
    render

    assert_select 'form[action=?][method=?]', staff_codes_path, 'post' do
      assert_select 'input[name=?]', 'staff_code[code]'

      assert_select 'input[name=?]', 'staff_code[points]'
    end
  end
end
