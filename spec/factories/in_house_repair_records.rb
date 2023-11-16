# frozen_string_literal: true

FactoryBot.define do
  factory :in_house_repair_record do
    repair_type { create(:controlled_vocabulary, vocabulary: 'repair_type', key: 'Mend Paper') }
    performed_by_user_id { create(:user) }
    minutes_spent { 10 }
    staff_code_id { 'C' }
    conservation_record { create(:conservation_record) }
  end
end
