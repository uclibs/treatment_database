# frozen_string_literal: true

FactoryBot.define do
  factory :conservation_record do
    date_received_in_preservation_services { '2019-06-11' }
    department do
      # Try to find an existing department entry or create a new one if none exists
      department_vocab = ControlledVocabulary.find_by(vocabulary: 'department', key: 'specific_department_key')
      department_vocab ||= FactoryBot.create(:controlled_vocabulary, vocabulary: 'department', key: 'specific_department_key', active: true)
      department_vocab.id # Explicitly return the ID
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
