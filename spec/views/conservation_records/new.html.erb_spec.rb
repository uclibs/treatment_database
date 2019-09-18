# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'conservation_records/new', type: :view do
  before(:each) do
    assign(:conservation_record, ConservationRecord.new(
                                   department: 'MyString',
                                   title: 'MyString',
                                   author: 'MyString',
                                   imprint: 'MyString',
                                   call_number: 'MyString',
                                   item_record_number: 'MyString',
                                   digitization: false
                                 ))
    @departments = ControlledVocabulary.where(vocabulary: 'departments', active: true)
  end

  it 'renders new conservation_record form' do
    render

    assert_select 'form[action=?][method=?]', conservation_records_path, 'post' do
      assert_select 'select[name=?]', 'conservation_record[department]'

      assert_select 'input[name=?]', 'conservation_record[title]'

      assert_select 'input[name=?]', 'conservation_record[author]'

      assert_select 'input[name=?]', 'conservation_record[imprint]'

      assert_select 'input[name=?]', 'conservation_record[call_number]'

      assert_select 'input[name=?]', 'conservation_record[item_record_number]'

      assert_select 'input[name=?]', 'conservation_record[digitization]'
    end
  end
end
