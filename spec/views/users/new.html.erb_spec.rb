# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/new.html.erb', type: :view do
  before(:each) do
    assign(:user, User.new(display_name: 'MyString',
                           email: 'MyString',
                           password: 'MyString',
                           password_confirmation: 'MyString',
                           role: 'MyString',
                           account_active: true))
  end

  it 'renders new User form' do
    render

    assert_select 'h1', text: 'Create New User'
    assert_select 'form[action=?][method=?]', users_path, 'post' do
      assert_select 'input[name=?]', 'user[display_name]'
      assert_select 'input[name=?]', 'user[email]'
      assert_select 'input[name=?]', 'user[password]'
      assert_select 'select[name=?]', 'user[role]'
      assert_select 'input[name=?]', 'user[account_active]'
    end
  end
end
