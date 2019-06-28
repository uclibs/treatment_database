# frozen_string_literal: true

FactoryBot.define do
  factory :controlled_vocabulary do
    vocabulary { 'MyString' }
    key { 'MyString' }
    active { false }
  end
end
