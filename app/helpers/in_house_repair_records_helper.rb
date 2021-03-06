# frozen_string_literal: true

module InHouseRepairRecordsHelper
  def generate_in_house_repair_string(ihrr, ind)
    repair_type = ControlledVocabulary.find(ihrr.repair_type).key
    display_name = User.find(ihrr.performed_by_user_id).display_name

    return "#{repair_type} performed by #{display_name} in #{ihrr.minutes_spent} minutes." if ind.nil?

    "#{ind + 1}. #{repair_type} performed by #{display_name} in #{ihrr.minutes_spent} minutes."
  end
end
