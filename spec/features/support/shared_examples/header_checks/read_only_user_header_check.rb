# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'has a read_only user header', type: :feature do
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

  it 'has a link to conservation records' do
    expect(@navbar).to have_link('Conservation Records', href: '/conservation_records')
  end

  it 'shows the user dropdown with the user\'s name and provides dropdown links' do
    # Ensure the dropdown button with the user's name is present and clickable
    expect(@navbar).to have_selector('button.dropdown-toggle', text: user.display_name)
    find('button.dropdown-toggle', text: user.display_name).click

    # After clicking, check for the dropdown menu items
    within('.dropdown-menu') do
      expect(@navbar).to have_link('Edit account', href: '/users/edit')
      expect(@navbar).to have_link('Logout', href: '/users/sign_out')
    end
  end

  it 'doesn\'t show the admin-specific links' do
    expect(@navbar).to_not have_link('Vocabularies', href: '/controlled_vocabularies')
    expect(@navbar).to_not have_link('Users', href: '/users')
    expect(@navbar).to_not have_link('Activity', href: '/activity')
    expect(@navbar).to_not have_link('Reports', href: '/reports')
  end
end
