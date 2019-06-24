# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'controlled_vocabularies/show', type: :view do
  before(:each) do
    @controlled_vocabulary = assign(:controlled_vocabulary, ControlledVocabulary.create!(
                                                              vocabulary: 'Vocabulary',
                                                              key: 'Key',
                                                              active: false
                                                            ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Vocabulary/)
    expect(rendered).to match(/Key/)
    expect(rendered).to match(/false/)
  end
end
