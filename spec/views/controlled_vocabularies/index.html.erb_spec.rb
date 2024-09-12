# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'controlled_vocabularies/index', type: :view do
  before(:each) do
    user = FactoryBot.create(:user, role: 'admin')
    view_login_as(user)
    view_stub_authorization(user)
    assign(:controlled_vocabularies, [
             ControlledVocabulary.create!(
               vocabulary: 'Pigeon',
               key: 'Bucket',
               active: false,
               favorite: true
             ),
             ControlledVocabulary.create!(
               vocabulary: 'Pigeon',
               key: 'Bucket',
               active: false,
               favorite: true
             )
           ])
  end

  it 'renders a list of controlled_vocabularies' do
    render
    assert_select 'tr>td', text: 'Pigeon'.to_s, count: 2
    assert_select 'tr>td', text: 'Bucket'.to_s, count: 2
    assert_select 'tr>td', text: false.to_s, count: 2
    assert_select 'tr>td', text: true.to_s, count: 2
    expect(rendered).to have_link('Bucket')
  end
end
