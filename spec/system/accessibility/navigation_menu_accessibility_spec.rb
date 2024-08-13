# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation Menu Accessibility', type: :system do
  it 'has no major accessibility violations on the navigation menu' do
    visit root_path
    check_accessibility_within('.navbar')
  end

  it 'is keyboard accessible' do
    visit root_path
    resize_window_to(768, 1024)
    find('.navbar-toggler').send_keys(:enter)
    expect(page).to have_css('.navbar-collapse', visible: true)
  end
end
