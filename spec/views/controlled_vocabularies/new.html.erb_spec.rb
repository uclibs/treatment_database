# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'controlled_vocabularies/new', type: :view do
  before(:each) do
    assign(:controlled_vocabulary, ControlledVocabulary.new(
                                     vocabulary: 'MyString',
                                     key: 'MyString',
                                     active: false
                                   ))
    @vocabularies = ControlledVocabulary.pluck(:vocabulary).uniq
  end

  it 'renders new controlled_vocabulary form' do
    render

    assert_select 'form[action=?][method=?]', controlled_vocabularies_path, 'post' do
      assert_select 'select[name=?]', 'controlled_vocabulary[vocabulary]'

      assert_select 'input[name=?]', 'controlled_vocabulary[key]'

      assert_select 'input[name=?]', 'controlled_vocabulary[active]'
    end
  end
end
