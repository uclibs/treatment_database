# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Report Generation', type: :feature, js: true do
  let(:user) { create(:user, role: 'admin') }

  before do
    user
  end

  it 'executes data export task on button click' do
    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'notapassword'
    click_button 'Login'
    expect(page).to have_content('Logged in successfully')

    visit reports_path
    click_on 'New Report'
    expect(page).to have_text 'Report may take a moment to complete.'
  end
end
