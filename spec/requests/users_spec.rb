# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:admin_user) { create(:user, role: :admin) }
  let(:inactive_user) { create(:user, account_active: false) }

  before do
    request_login_as admin_user
  end

  it 'allows admin to update account_active status' do
    # Admin updates account_active to true
    patch admin_user_path(inactive_user), params: { user: { account_active: true } }
    expect(inactive_user.reload.account_active).to be true

    # Admin updates account_active to false
    patch admin_user_path(inactive_user), params: { user: { account_active: false } }
    expect(inactive_user.reload.account_active).to be false
  end
end
