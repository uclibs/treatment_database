# frozen_string_literal: true

module InHouseRepairRecordsHelper
  def display_name(ihrr)
    user_display_name(ihrr.performed_by_user_id)
  end

  def generate_in_house_repair_string(ihrr, ind)
    repair_type = ControlledVocabulary.find(ihrr.repair_type).key

    if ind.nil?
      return "#{repair_type} performed by #{display_name(ihrr)} in #{ihrr.minutes_spent} minutes. #{if ihrr.other_note.present?
                                                                                                      "Other note: #{ihrr.other_note}"
                                                                                                    end}. #{if ihrr.staff_code.present?
                                                                                                              "Staff Code: #{ihrr.staff_code.code}"
                                                                                                            end}"
    end

    "#{ind + 1}. #{repair_type} performed by #{display_name(ihrr)} in #{ihrr.minutes_spent} minutes. #{if ihrr.other_note.present?
                                                                                                         "Other note: #{ihrr.other_note}"
                                                                                                       end}. #{if ihrr.staff_code.present?
                                                                                                                 "Staff Code: #{ihrr.staff_code.code}"
                                                                                                               end}"
  end
end
