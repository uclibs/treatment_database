# frozen_string_literal: true

FactoryBot.define do
  factory :conservation_record do
    date_recieved_in_preservation_services { '2019-06-11' }
    department { 'Department A' }
    title { 'A Farewell to Arms' }
    author { 'Ernest Hemmingway' }
    imprint { 'Scribner' }
    call_number { '1234' }
    item_record_number { '5678' }
    digitization { false }
  end
end
