# frozen_string_literal: true

FactoryBot.define do
  factory :con_tech_record do
    performed_by_user_id { create(:user) }
    conservation_record { create(:conservation_record) }
  end
end
