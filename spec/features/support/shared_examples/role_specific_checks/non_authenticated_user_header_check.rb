# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'has a non_authenticated user header', type: :feature do
  before do
    visit root_path
    within('nav.navbar') do
      @navbar = page
    end
  end

  it 'displays the treatment database link' do
    expect(@navbar).to have_link('Treatment Database', href: '/')
  end

  it 'provides a log in link' do
    expect(@navbar).to have_link('Log in', href: '/users/sign_in')
  end

  it 'doesn\'t show the logged-in user links' do
    expect(@navbar).to_not have_link('Conservation Records', href: '/conservation_records')
    expect(@navbar).to_not have_link('Vocabularies', href: '/controlled_vocabularies')
    expect(@navbar).to_not have_link('Users', href: '/users')
    expect(@navbar).to_not have_link('Activity', href: '/activity')
    expect(@navbar).to_not have_link('Reports', href: '/reports')
  end
end
