# frozen_string_literal: true

FactoryBot.define do
  factory :treatment_report do
    description_general_remarks { 'description_general_remarks' }
    description_binding { 'description_binding' }

    # A transient attribute that won't persist to the database but can be used in the factory
    transient do
      conservation_record { nil }
    end

    after(:build) do |treatment_report, evaluator|
      if evaluator.conservation_record
        treatment_report.conservation_record = evaluator.conservation_record
      else
        treatment_report.conservation_record ||= FactoryBot.create(:conservation_record)
      end
    end
  end
end
