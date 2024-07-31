# frozen_string_literal: true

FactoryBot.define do
  factory :conservation_record do
    date_received_in_preservation_services { '2019-06-11' }
    department do
      ControlledVocabulary.find_or_create_by(vocabulary: 'department', active: true) do |cv|
        cv.key = 'some_key'
      end.id
    end
    title { 'The Illiad' }
    author { 'James Joyce' }
    imprint { 'Dutton' }
    call_number { '102340' }
    item_record_number { 'i3445' }
    digitization { false }

    factory :conservation_record_with_cost_return_report do
      after(:create) do |conservation_record|
        create(:cost_return_report, conservation_record:)
      end
    end
  end
end
