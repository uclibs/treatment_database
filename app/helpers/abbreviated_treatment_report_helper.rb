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

  def generate_sum_minutes(conservation_record)
    sum = 0
    conservation_record.in_house_repair_records.each_with_index do |repair, _i|
      sum += repair.minutes_spent
    end
    if sum > 60
      "#{sum / 60} hours"
    else
      "#{sum} minutes"
    end
  end
end
