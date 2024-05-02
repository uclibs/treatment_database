# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'view staff codes' do
  it 'allows viewing the staff codes page' do
    within('nav.navbar') do
      expect(page).to have_link(nil, href: staff_codes_path)
    end
    visit staff_codes_path
    expect(page).to have_selector('h1', text: 'Staff Codes')
    expect(page).to have_content('Code Points')
    expect(page).to have_link('New Staff Code', href: '/staff_codes/new')
    expect(page).not_to have_link('Destroy')
    expect(page).to have_link('Show')
  end
end
