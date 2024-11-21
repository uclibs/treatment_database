# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/index.html.erb', type: :view do
  let(:admin_user) do
    User.create!(
      display_name: 'Admin User',
      email: 'admin_user@uc.edu',
      role: 'admin',
      password: 'testpassword',
      username: 'admin_user'
    )
  end

  let(:read_only_user) do
    User.create!(
      display_name: 'Test User 1',
      email: 'test_user1@uc.edu',
      role: 'read_only',
      password: 'testpassword',
      username: 'test_user1'
    )
  end

  let(:standard_user) do
    User.create!(
      display_name: 'Test User 2',
      email: 'test_user2@uc.edu',
      role: 'standard',
      password: 'testpassword',
      username: 'test_user2'
    )
  end

  before(:each) do
    assign(:users, [read_only_user, standard_user, admin_user])
  end

  it 'renders the view' do
    render
    expect(rendered).to have_link('Add New User')
    expect(rendered).to include('Users')
    expect(rendered).to have_link('Test User 1')
    expect(rendered).to have_link('Test User 2')
    expect(rendered).to have_link('Admin User')
    expect(rendered).to include('read_only')
    expect(rendered).to include('standard')
    expect(rendered).to include('admin')
  end
end
