FactoryBot.define do
  factory :external_repair_record do
    repair_type { 1 }
    performed_by_user_id { 1 }
    conservation_record { nil }
  end
end
