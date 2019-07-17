# frozen_string_literal: true

FactoryBot.define do
  factory :conservation_record do
    date_recieved_in_preservation_services { '2019-06-11' }
    department { 'Department A' }
    title { 'The Illiad' }
    author { 'James Joyce' }
    imprint { 'Dutton' }
    call_number { '102340' }
    item_record_number { 'ir3445' }
    digitization { false }
  end
end
