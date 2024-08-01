# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'controlled_vocabularies/index', type: :view do

  before(:each) do
    assign(:controlled_vocabularies, [
             ControlledVocabulary.create!(
               vocabulary: 'Vocabulary',
               key: 'Key',
               active: false,
               favorite: true
             ),
             ControlledVocabulary.create!(
               vocabulary: 'Vocabulary',
               key: 'Key',
               active: false,
               favorite: true
             )
           ])
  end

  it 'renders a list of controlled_vocabularies' do
    render
    assert_select 'tr>td', text: 'Vocabulary'.to_s, count: 2
    assert_select 'tr>td', text: 'Key'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: true.to_s, count: 2
    expect(rendered).to have_link('Key')
  end
end
