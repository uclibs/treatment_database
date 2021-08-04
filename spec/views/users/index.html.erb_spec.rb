# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index.html.erb', type: :view do
  include Devise::Test::ControllerHelpers
  before(:each) do
    assign(:users, [
             User.create!(
               display_name: 'Test User 1',
               email: 'test_user1@example.com',
               role: 'reader',
               password: 'testpassword'
             ),
             User.create!(
               display_name: 'Test User 2',
               email: 'test_user2@example.com',
               role: 'standard_user',
               password: 'testpassword'
             )
           ])
  end

  it 'allows admins to edit users' do
    @user_admin = create(:user, role: 'admin')
    @request.env['devise.mapping'] = Devise.mappings[:user_admin]
    sign_in @user_admin
    render
    expect(rendered).to have_link('Test User 1')
  end

  it 'renders a list of users' do
    render
    assert_select 'tr>td', text: 'Test User 1'
    assert_select 'tr>td', text: 'Test User 2'
    assert_select 'tr>td', text: 'reader'
    assert_select 'tr>td', text: 'standard_user'
    assert_select 'tr>td', text: 'test_user1@example.com'
    assert_select 'tr>td', text: 'test_user2@example.com'
  end

  it 'allows admins to create users' do
    @user = create(:user, role: 'admin')
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    render
    expect(rendered).to have_link('Add New User')
  end

  it 'does not allow standard users to create users' do
    @user = create(:user, role: 'standard')
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    render
    expect(rendered).not_to have_link('Add New User')
  end

  it 'does not allow read_only users to create users' do
    @user = create(:user, role: 'read_only')
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    render
    expect(rendered).not_to have_link('Add New User')
  end
end
