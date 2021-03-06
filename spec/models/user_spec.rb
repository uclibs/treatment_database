# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid when all required fields are provided' do
    user = User.new(email: 'test@example.com', password: 'notapassword', display_name: 'Bobby Tables')
    expect(user).to be_valid
  end

  it 'is not valid without a display name' do
    user = User.new(email: 'test@example.com', password: 'notapassword')
    expect(user).to_not be_valid
  end

  it 'is not valid without an email' do
    user = User.new(password: 'notapassword', display_name: 'Bobby Tables')
    expect(user).to_not be_valid
  end

  it 'is not valid without a password' do
    user = User.new(email: 'test@example.com', display_name: 'Bobby Tables')
    expect(user).to_not be_valid
  end

  it 'activates new account on creation' do
    user = User.new(email: 'test@example.com', display_name: 'Bobby Tables')
    expect(user.account_active).to be true
  end

  it 'set default role for new users' do
    user = User.create(email: 'test@example.com', display_name: 'Bobby Tables')
    expect(user.role).to eq 'read_only'
  end
end
