# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'view activity' do
  it 'allows viewing the Activity page' do
    # within('nav.navbar') do
    #   expect(page).to have_link(nil, href: '/activity') # We use /activity instead of /activities for the path
    # end
    visit '/activity' # We use /activity instead of /activities for the path
    expect(page).to have_selector('h1', text: 'Recent Activity')
    expect(page).to have_css('table thead tr th', text: 'Activity')
    expect(page).to have_css('table thead tr th', text: 'When')
    expect(page).to have_css('table thead tr th', text: 'Detail')
  end
end
