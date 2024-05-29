# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'edits users' do
  let(:user_to_edit) { create(:user, display_name: 'Daffy Duck') }

  before do
    user_to_edit
  end

  it 'edits a user' do
    visit users_path
    expect(page).to have_selector('h1', text: 'Users')
    expect(page).to have_link('Daffy Duck', href: edit_user_path(user_to_edit))
    click_on 'Daffy Duck'

    expect(page).to have_selector('h1', text: 'Edit User')
    fill_in 'Display name', with: 'Minnie Mouse'
    click_on 'Update User'

    # There is currently no flash message for updating users
    expect(flash_notice).not_to be_present
    expect(page).to have_selector('h1', text: 'Users')
    expect(page).to have_content('Minnie Mouse')
    expect(page).not_to have_content('Daffy Duck')
  end
end
