# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/index.html.erb', type: :view do
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


  it 'renders a list of users' do
    render
    assert_select 'tr>td', text: 'Test User 1'
    assert_select 'tr>td', text: 'Test User 2'
    assert_select 'tr>td', text: 'reader'
    assert_select 'tr>td', text: 'standard_user'
    assert_select 'tr>td', text: 'test_user1@example.com'
    assert_select 'tr>td', text: 'test_user2@example.com'
  end


end
