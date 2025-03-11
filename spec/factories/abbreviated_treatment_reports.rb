# frozen_string_literal: true

FactoryBot.define do
  factory :abbreviated_treatment_report do
    association :conservation_record
  end
end
