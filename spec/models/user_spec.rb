# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid when all required fields are provided' do
    user = User.new(display_name: 'Bobby Tables', username: 'test')
    expect(user).to be_valid
  end

  it 'is not valid without a display name' do
    user = User.new(username: 'test')
    expect(user).to_not be_valid
  end

  it 'activates new account on creation' do
    user = User.new(username: 'test')
    expect(user.account_active).to be true
  end

  it 'sets new users to the read_only role by default' do
    user = User.create(display_name: 'Bobby Tables', username: 'test')
    expect(user.role).to eq 'read_only'
  end
end
