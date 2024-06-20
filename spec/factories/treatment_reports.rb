# frozen_string_literal: true

FactoryBot.define do
  factory :treatment_report do
    description_general_remarks { 'description_general_remarks' }
    description_binding { 'description_binding' }
    association :conservation_record
  end
end
