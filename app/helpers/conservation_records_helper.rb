# frozen_string_literal: true

module ConservationRecordsHelper
  def generate_in_house_repair_string(ihrr)
    repair_type = ControlledVocabulary.find(ihrr.repair_type).key
    display_name = User.find(ihrr.performed_by_user_id).display_name

    repair_type + ' performed by ' + display_name + ' in ' + ihrr.minutes_spent.to_s + ' minutes.'
  end
end
