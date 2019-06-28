# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/edit', type: :view do
  before(:each) do
    @conservation_record = assign(:conservation_record, ConservationRecord.create!(
                                                          department: 'MyString',
                                                          title: 'MyString',
                                                          author: 'MyString',
                                                          imprint: 'MyString',
                                                          call_number: 'MyString',
                                                          item_record_number: 'MyString',
                                                          digitization: false
                                                        ))
  end

  it 'renders the edit conservation_record form' do
    render

    assert_select 'form[action=?][method=?]', conservation_record_path(@conservation_record), 'post' do
      assert_select 'input[name=?]', 'conservation_record[department]'

      assert_select 'input[name=?]', 'conservation_record[title]'

      assert_select 'input[name=?]', 'conservation_record[author]'

      assert_select 'input[name=?]', 'conservation_record[imprint]'

      assert_select 'input[name=?]', 'conservation_record[call_number]'

      assert_select 'input[name=?]', 'conservation_record[item_record_number]'

      assert_select 'input[name=?]', 'conservation_record[digitization]'
    end
  end
end
