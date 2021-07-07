# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/edit.html.erb', type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
                            display_name: 'Test User 1',
                            email: 'testuser@example.com',
                            role: 'reader',
                            password: 'testpass'
                          ))
  end

  it 'renders the edit user form' do
    render

    assert_select 'h1', text: 'Edit User'
    assert_select 'form[action=?][method=?]', user_path(@user), 'post' do
      assert_select 'input[name=?]', 'user[display_name]'
      assert_select 'input[name=?]', 'user[email]'
      assert_select 'select[name=?]', 'user[role]'
      assert_select 'input[name=?]', 'user[account_active]'
      expect(rendered).to have_button('Update User')
    end
  end
end
