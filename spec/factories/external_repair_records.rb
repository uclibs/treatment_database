# frozen_string_literal: true

FactoryBot.define do
  factory :external_repair_record do
    repair_type { create(:controlled_vocabulary, vocabulary: 'repair_type', key: 'Mend Paper').id }
    performed_by_vendor_id { create(:controlled_vocabulary, vocabulary: 'contract_conservator', key: 'Contract Conservator').id }
    conservation_record { create(:conservation_record) }
  end
end
