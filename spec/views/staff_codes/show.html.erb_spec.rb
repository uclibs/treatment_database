# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'staff_codes/show', type: :view do
  before(:each) do
    @staff_code = assign(:staff_code, StaffCode.create!(
                                        code: 'Code',
                                        points: 2
                                      ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/2/)
  end
end
