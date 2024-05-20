# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:display_name) { |n| "Name #{n}" }
    sequence(:email) { |n| "user#{n}_#{Time.now.to_i}@example.com" }
    password { 'notapassword' }
    role { 'standard' }
    account_active { true }
  end
end
