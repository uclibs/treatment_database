# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'staff_codes/edit', type: :view do
  before(:each) do
    @staff_code = assign(:staff_code, StaffCode.create!(
                                        code: 'MyString',
                                        points: 1
                                      ))
  end

  it 'renders the edit staff_code form' do
    render

    assert_select 'form[action=?][method=?]', staff_code_path(@staff_code), 'post' do
      assert_select 'input[name=?]', 'staff_code[code]'

      assert_select 'input[name=?]', 'staff_code[points]'
    end
  end
end
