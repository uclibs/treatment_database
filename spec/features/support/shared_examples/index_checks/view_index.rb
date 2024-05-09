# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'index page access for authenticated users' do
  it 'allows the user to view the index page' do
    within('nav.navbar') do
      expect(page).to have_link(nil, href: conservation_records_path)
    end
    visit conservation_records_path
    expect(page).to have_selector('h1', text: 'Conservation Records')
  end
end
