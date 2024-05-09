# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'view reports' do
  it 'allows viewing the reports page' do
    within('nav.navbar') do
      expect(page).to have_link(nil, href: reports_path)
    end
    visit reports_path
    expect(page).to have_selector('h1', text: 'Reports')
    expect(page).to have_link('New Report', href: '/reports')
  end
end
