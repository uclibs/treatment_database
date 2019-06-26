# frozen_string_literal: true

FactoryBot.define do
  factory :in_house_repair_record do
    repair_type { 'Type 1' }
    performed_by_user_id { 1 }
    minutes_spent { 1 }
    ConservationRecord { nil }
  end
end
