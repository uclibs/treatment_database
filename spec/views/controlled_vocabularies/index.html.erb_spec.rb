# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'controlled_vocabularies/index', type: :view do

include Devise::Test::ControllerHelpers

  before(:each) do
    assign(:controlled_vocabularies, [
             ControlledVocabulary.create!(
               vocabulary: 'Vocabulary',
               key: 'Key',
               active: false
             ),
             ControlledVocabulary.create!(
               vocabulary: 'Vocabulary',
               key: 'Key',
               active: false
             )
           ])
  end

  it 'renders a list of controlled_vocabularies' do
    render
    assert_select 'tr>td', text: 'Vocabulary'.to_s, count: 2
    assert_select 'tr>td', text: 'Key'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
  end
end
