# frozen_string_literal: true

FactoryBot.define do
  factory :controlled_vocabulary do
    vocabulary { 'vocabulary_string' }
    key { 'key_string' }
    active { false }
  end
end
