# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Navigation Menu', type: :system do
  it 'displays the full menu on large screens' do
    resize_window_to(1024, 768)
    visit root_path

    # Ensure the navbar is expanded and visible
    expect(page).to have_css('.navbar', visible: true)
    expect(page).to have_css('.navbar-collapse.collapse', visible: true)

    # Ensure the 'Log in' link is visible when the menu is expanded
    expect(page).to have_css('.navbar-collapse .nav-link', text: 'Log in', visible: true)

    # Ensure the navbar-toggler is not visible
    expect(page).to have_no_css('.navbar-toggler', visible: true)
  end

  it 'displays the hamburger menu on small screens' do
    resize_window_to(375, 667)
    visit root_path

    # Ensure the navbar-toggler (hamburger menu) is visible
    expect(page).to have_css('.navbar-toggler', visible: true)

    # Ensure the navbar is collapsed by default
    expect(page).to have_css('.navbar-collapse.collapse', visible: false)

    # Click the navbar-toggler to expand the menu
    find('.navbar-toggler').click

    # Ensure the navbar expands after toggling
    expect(page).to have_css('.navbar-collapse.collapse', visible: true)

    # Ensure the 'Log in' link is visible when the menu is expanded
    expect(page).to have_css('.navbar-collapse .nav-link', text: 'Log in', visible: true)
  end
end
