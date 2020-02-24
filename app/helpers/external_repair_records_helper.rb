# frozen_string_literal: true

module ExternalRepairRecordsHelper
  def generate_external_repair_string(err, ind)
    repair_type = ControlledVocabulary.find(err.repair_type).key
    contract_conservator_name = ControlledVocabulary.find(err.performed_by_vendor_id).key

    repair_type + ' performed by ' + contract_conservator_name.squish + '.'
  end
end
