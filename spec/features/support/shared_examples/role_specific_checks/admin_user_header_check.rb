# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'has an admin user header', type: :feature do
  it_behaves_like 'Navbar Search Behavior'

  before do
    visit root_path
    within('nav.navbar') do
      @navbar = page
    end
  end

  it 'displays the treatment database link' do
    expect(@navbar).to have_link('Treatment Database', href: '/')
  end

  it 'includes links to admin-specific sections' do
    expect(@navbar).to have_link('Conservation Records', href: '/conservation_records')
    expect(@navbar).to have_link('Vocabularies', href: '/controlled_vocabularies')
    expect(@navbar).to have_link('Users', href: '/users')
    expect(@navbar).to have_link('Activity', href: '/activity')
    expect(@navbar).to have_link('Reports', href: '/reports')
    expect(@navbar).to have_link('Staff Codes', href: '/staff_codes')
  end

  it 'shows the user dropdown with the admin\'s name and provides dropdown links' do
    expect(@navbar).to have_selector('button.dropdown-toggle', text: user.display_name)
    find('button.dropdown-toggle', text: user.display_name).click

    within('.dropdown-menu') do
      expect(@navbar).to have_link('Edit account', href: '/users/edit')
      expect(@navbar).to have_link('Logout', href: '/users/sign_out')
    end
  end
end
