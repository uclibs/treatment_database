# frozen_string_literal: true

module AbbreviatedTreatmentReportHelper
  def generate_abbreviated_treatment_report_type(ihrr, _ind)
    ControlledVocabulary.find(ihrr.repair_type).key
  end

  def generate_abbreviated_treatment_report_performed_by(ihrr, _ind)
    User.find(ihrr.performed_by_user_id).display_name
  end

  def generate_abbreviated_treatment_report_time(ihrr, _ind)
    ihrr.minutes_spent.to_s
  end

  def conservators_note(ihrr, _ind)
    ihrr.conservators_note
  end
end
