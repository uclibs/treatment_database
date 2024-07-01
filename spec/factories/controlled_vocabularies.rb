# frozen_string_literal: true

FactoryBot.define do
  factory :controlled_vocabulary do
    vocabulary { 'vocabulary_string' }
    key { 'key_string' }
    active { false }

    trait :active do
      active { true }
    end
  end
end
