# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:display_name) { |n| "Name #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'notapassword' }
    role { 'standard' }
  end
end
