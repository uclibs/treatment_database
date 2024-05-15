# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:display_name) { |n| "Name #{n}" }
    sequence(:email) { |n| "user#{n}_#{Time.now.to_i}@example.com" }
    password { 'notapassword' }
    # dont think we need : role { 'standard' }
    account_active { true }
  end
end

# The following is from ucrate's user factory:
#  factory :shibboleth_user, class: 'User' do
#       transient do
#         count { 1 }
#         person_pid { nil }
#       end
# *****      email { 'sixplus2@test.com' }
#       password { '12345678' }
#       first_name { 'Fake' }
#       last_name { 'User' }
#       password_confirmation { '12345678' }
#       sign_in_count { count.to_s }
#       provider { 'shibboleth' }
#       uid { 'sixplus2@test.com' }
#     end