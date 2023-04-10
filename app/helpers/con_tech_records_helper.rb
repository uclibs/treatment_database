# frozen_string_literal: true

module ConTechRecordsHelper
  def generate_con_tech_string(ihrr, ind)
    display_name = user_display_name(ihrr.performed_by_user_id)

    return display_name if ind.nil?

    "#{ind + 1}. #{display_name}"
  end
end
