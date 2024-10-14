# frozen_string_literal: true

module InHouseRepairRecordsHelper
  def display_name(ihrr)
    user_display_name(ihrr.performed_by_user_id)
  end

  def generate_in_house_repair_string(ihrr, ind)
    repair_type = controlled_vocabulary_lookup(ihrr.repair_type)
    base_string = "#{repair_type} performed by #{display_name(ihrr)} in #{ihrr.minutes_spent} minutes."

    if ind.nil?
      return "#{base_string}#{" Other note: #{ihrr.other_note}." if ihrr.other_note.present?} Staff Code: #{ihrr.staff_code.code}"
    end

    "#{ind + 1}. #{base_string}#{" Other note: #{ihrr.other_note}." if ihrr.other_note.present?} Staff Code: #{ihrr.staff_code.code}"
  end
end
