# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/edit.html.erb', type: :view do
  before(:each) do
    @user = create(:user)
    admin_user = create(:user, role: 'admin')
    view_login_as(admin_user)
    view_stub_authorization(admin_user)
  end

  it 'renders the edit user form' do # frozen_string_literal: true
    require 'rails_helper'

    RSpec.describe 'admin/users/edit.html.erb', type: :view do
      before(:each) do
        @user = assign(:user, create(:user))
        admin_user = create(:user, role: 'admin')
        view_login_as(admin_user)
        view_stub_authorization(admin_user)
      end

      it 'renders the edit user form' do
        render
        assert_select 'h1', text: 'Edit User'
        assert_select 'form[action=?][method=?]', edit_user_path(@user), 'post' do
          assert_select 'input[name=?]', 'user[display_name]'
          assert_select 'input[name=?]', 'user[email]'
          assert_select 'select[name=?]', 'user[role]'
          assert_select 'input[name=?]', 'user[account_active]'
          expect(rendered).to have_button('Update User')
        end
      end
    end
  end
end
