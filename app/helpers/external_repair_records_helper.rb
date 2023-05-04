# frozen_string_literal: true

module ExternalRepairRecordsHelper
  def generate_external_repair_string(err, ind)
    repair_type = controlled_vocabulary_lookup(err.repair_type)
    contract_conservator_name = controlled_vocabulary_lookup(err.performed_by_vendor_id)

    return "#{repair_type}performed by #{contract_conservator_name}. #{"Other note: #{err.other_note}" if err.other_note.present?}" if ind.nil?

    "#{ind + 1}. #{repair_type} performed by #{contract_conservator_name}. #{"Other note: #{err.other_note}" if err.other_note.present?}"
  end
end
