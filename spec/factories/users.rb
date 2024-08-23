# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    transient do
      n { generate(:user_sequence) } # Use a transient attribute to hold the sequence value
    end

    sequence(:display_name) { |n| "Name #{n}" }
    sequence(:email) { |n| "user#{n}_#{Time.now.to_i}@uc.edu" }
    password { 'notapass' }
    password_confirmation { 'notapass' }
    role { 'standard' }
    account_active { true }
    username { "user#{n}_#{Time.now.to_i}" }
  end
end

FactoryBot.define do
  sequence(:user_sequence) { |n| n }
end
