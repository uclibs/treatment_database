# frozen_string_literal: true

FactoryBot.define do
  factory :in_house_repair_record do
    type { '' }
    performed_by_user_id { 1 }
    minutes_spent { 1 }
    ConservationRecord { nil }
  end
end
