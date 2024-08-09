# frozen_string_literal: true

FactoryBot.define do
  factory :in_house_repair_record do
    repair_type { FactoryBot.create(:controlled_vocabulary, :active, vocabulary: 'repair_type', key: 'Mend Paper').id }
    performed_by_user_id { FactoryBot.create(:user).id }
    minutes_spent { 10 }
    staff_code { FactoryBot.create(:staff_code, code: 'C') }
    association :conservation_record
  end
end
