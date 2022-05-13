# frozen_string_literal: true

module InHouseRepairRecordsHelper
  def generate_in_house_repair_string(ihrr, ind)
    repair_type = ControlledVocabulary.find(ihrr.repair_type).key
    display_name = User.find(ihrr.performed_by_user_id).display_name

    if ind.nil?
      return "#{repair_type} performed by #{display_name} in #{ihrr.minutes_spent} minutes. #{if ihrr.other_note.present?
                                                                                                "Other note: #{ihrr.other_note}"
                                                                                              end}. #{if ihrr.staff_code.present?
                                                                                                        "Staff Code: #{ihrr.staff_code.code}"
                                                                                                      end}"
    end

    "#{ind + 1}. #{repair_type} performed by #{display_name} in #{ihrr.minutes_spent} minutes. #{if ihrr.other_note.present?
                                                                                                   "Other note: #{ihrr.other_note}"
                                                                                                 end}. #{if ihrr.staff_code.present?
                                                                                                           "Staff Code: #{ihrr.staff_code.code}"
                                                                                                         end}"
  end
end
