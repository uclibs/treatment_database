# frozen_string_literal: true

FactoryBot.define do
  factory :cost_return_report do
    shipping_cost { 100.10 }
    repair_estimate { 110.10 }
    repair_cost { 120.10 }
    invoice_sent_to_business_office { Time.now.utc }
    complete { true }
    returned_to_origin { Time.now.utc }
    note { 'This is the note.' }
  end
end
