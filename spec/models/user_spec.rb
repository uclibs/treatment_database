# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid when all required fields are provided' do
    user = User.new(email: 'test@uc.edu', password: 'notapass', display_name: 'Bobby Tables', username: 'test')
    expect(user).to be_valid
  end

  it 'is not valid without a display name' do
    user = User.new(email: 'test@uc.edu', password: 'notapass', username: 'test')
    expect(user).to_not be_valid
  end

  it 'is not valid without an email' do
    user = User.new(password: 'notapass', display_name: 'Bobby Tables', username: 'test')
    expect(user).to_not be_valid
  end

  it 'is not valid without a password' do
    user = User.new(email: 'test@uc.edu', display_name: 'Bobby Tables', username: 'test')
    expect(user).to_not be_valid
  end

  it 'activates new account on creation' do
    user = User.new(email: 'test@uc.edu', display_name: 'Bobby Tables', username: 'test')
    expect(user.account_active).to be true
  end

  it 'set default role for new users' do
    user = User.create(email: 'test@uc.edu', display_name: 'Bobby Tables', password: 'notapass', username: 'test')
    expect(user.role).to eq 'read_only'
  end
end
