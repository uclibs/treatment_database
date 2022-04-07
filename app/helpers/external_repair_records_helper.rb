# frozen_string_literal: true

module ExternalRepairRecordsHelper
  def generate_external_repair_string(err, ind)
    repair_type = ControlledVocabulary.find(err.repair_type).key
    contract_conservator_name = ControlledVocabulary.find(err.performed_by_vendor_id).key

    return "#{repair_type}performed by #{contract_conservator_name.squish}. #{"Other note: #{err.other_note}" if err.other_note.present?}" if ind.nil?

    "#{ind + 1}. #{repair_type} performed by #{contract_conservator_name.squish}. #{"Other note: #{err.other_note}" if err.other_note.present?}"
  end
end
