# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/edit.html.erb', type: :view do
  before(:each) do
    @user = assign(:user, create(:user)) # Assign user to the view
    admin_user = create(:user, role: 'admin')
    view_login_as(admin_user) # Stub helper method to log in the admin
    view_stub_authorization(admin_user) # Stub authorization
  end

  it 'renders the edit user form' do
    render # Renders the edit.html.erb view

    # Check if the page contains an h1 tag with the text 'Edit User'
    expect(rendered).to have_selector('h1', text: 'Edit User')

    # Check the form action and method (method will be POST with a hidden field for PATCH)
    expect(rendered).to have_selector("form[action='#{admin_user_path(@user)}'][method='post']") do
      # Check for the hidden _method field with value 'patch'
      expect(rendered).to have_selector('input[name="_method"][value="patch"]', visible: false)

      # Check that the form contains the appropriate input fields
      expect(rendered).to have_selector('input[name="user[display_name]"]')
      expect(rendered).to have_selector('input[name="user[email]"]')
      expect(rendered).to have_selector('input[name="user[password]"]')
      expect(rendered).to have_selector('input[name="user[password_confirmation]"]')
      expect(rendered).to have_selector('select[name="user[role]"]')
      expect(rendered).to have_selector('input[name="user[account_active]"]')

      # Check that the form has a submit button with the text 'Update User'
      expect(rendered).to have_button('Update User')
    end
  end
end
