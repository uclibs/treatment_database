# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Read Only User Tests', type: :feature, js: true do
  let(:user) { create(:user, role: 'read_only') }
  let(:conservation_record) { create(:conservation_record, title: 'Farewell to Arms', department: 'ARB Library') }
  let!(:staff_code) { create(:staff_code, code: 'test', points: 10) }

  before do
    user
    conservation_record
    staff_code
  end

  it 'allows User to login and show Conservation Records' do
    # Login

    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Login'
    sleep 5

    expect(page).to have_content('Logged in successfully')
    expect(page).to have_link('Conservation Records')

    # Show Conservation Records

    click_on 'Conservation Records'
    expect(page).to have_content('Conservation Records')
    expect(page).to have_no_link('Add Conservation Record')
    expect(page).to have_no_link('Destroy')
    expect(page).to have_no_link('Edit', text: 'Edit', exact_text: true)
    expect(page).to have_no_link('Show')
    click_link(conservation_record.title, match: :prefer_exact)
    expect(page).to have_content(conservation_record.title)
    expect(page).to have_no_link('Edit Conservation Record')
    expect(page).to have_no_button('Add In-House Repairs')
    expect(page).to have_no_button('Add External Repair')
    expect(page).to have_no_button('Add Conservators and Technicians')
    expect(page).to have_button('Save Treatment Report', disabled: true)
    expect(page).to have_button('Save Cost and Return Information', disabled: true)
  end
end
