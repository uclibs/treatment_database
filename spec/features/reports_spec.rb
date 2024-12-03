# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Report Generation', type: :feature, js: true do
  let(:user) { create(:user, role: 'admin') }

  it 'executes data export task on button click' do
    visit dev_login_path
    fill_in 'Username', with: user.username
    click_button 'Submit'
    expect(page).to have_content('Signed in successfully')

    visit reports_path
    click_on 'New Report'
    expect(page).to have_text 'Report may take a moment to complete.'
  end
end
