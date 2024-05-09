# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'view controlled vocabularies' do
  it 'allows viewing the Controlled Vocabularies page' do
    within('nav.navbar') do
      expect(page).to have_link(nil, href: controlled_vocabularies_path)
    end
    visit controlled_vocabularies_path
    expect(page).to have_selector('h1', text: 'Controlled Vocabularies')
    expect(page).to have_link('New Controlled Vocabulary', href: '/controlled_vocabularies/new', class: 'btn btn-primary justify-content-right')
  end
end
