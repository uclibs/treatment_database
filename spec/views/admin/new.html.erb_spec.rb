# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/new.html.erb', type: :view do
  before(:each) do
    @user = assign(:user, User.new) # Assign a new user instance to the view
    admin_user = create(:user, role: 'admin')
    view_login_as(admin_user) # Stub helper method to log in the admin
    view_stub_authorization(admin_user) # Stub authorization
  end

  it 'renders the new user form' do
    render # Renders the new.html.erb view

    # Check if the page contains an h1 tag with the text 'New User'
    expect(rendered).to have_selector('h1', text: 'New User')

    # Check the form action and method
    expect(rendered).to have_selector("form[action='#{admin_users_path}'][method='post']") do
      # Check that the form contains the appropriate input fields
      expect(rendered).to have_selector('input[name="user[display_name]"]')
      expect(rendered).to have_selector('input[name="user[email]"]')
      expect(rendered).to have_selector('input[name="user[password]"]')
      expect(rendered).to have_selector('input[name="user[password_confirmation]"]')
      expect(rendered).to have_selector('select[name="user[role]"]')
      expect(rendered).to have_selector('input[name="user[account_active]"]')

      # Check that the form has a submit button with the text 'Create User'
      expect(rendered).to have_button('Create User')
    end
  end
end
