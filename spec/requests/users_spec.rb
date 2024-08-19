# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:admin_user) { create(:user, role: :admin) }
  let(:user) { create(:user, account_active: false) }

  before do
    controller_login_as admin_user # Sign in as an admin user
    controller_stub_authorization admin_user # Stub the ability
  end

  it 'allows admin to update account_active status' do
    # Admin updates account_active to true
    patch user_path(user), params: { user: { account_active: true } }
    expect(user.reload.account_active).to be true

    # Admin updates account_active to false
    patch user_path(user), params: { user: { account_active: false } }
    expect(user.reload.account_active).to be false
  end
end
