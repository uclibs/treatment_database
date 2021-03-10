# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'controlled_vocabularies/edit', type: :view do
  before(:each) do
    @controlled_vocabulary = assign(:controlled_vocabulary, ControlledVocabulary.create!(
                                                              vocabulary: 'MyString',
                                                              key: 'MyString',
                                                              active: false
                                                            ))
  end

  it 'renders the edit controlled_vocabulary form' do
    render

    assert_select 'form[action=?][method=?]', controlled_vocabulary_path(@controlled_vocabulary), 'post' do
      assert_select 'select[name=?]', 'controlled_vocabulary[vocabulary]'

      assert_select 'input[name=?]', 'controlled_vocabulary[key]'

      assert_select 'input[name=?]', 'controlled_vocabulary[active]'
    end
  end
end
