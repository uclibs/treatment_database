# frozen_string_literal: true

module AbbreviatedTreatmentReportHelper
  def generate_abbreviated_treatment_report_type(ihrr, _ind)
    ControlledVocabulary.find(ihrr.repair_type).key
  end

  def generate_abbreviated_treatment_report_performed_by(ihrr, _ind)
    user_display_name(ihrr.performed_by_user_id)
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

  def convert_legacy_treatment_report_to_rtf(treatment_report)
    return unless treatment_report && treatment_report.abbreviated_treatment_report.present?

    # Check if an abbreviated treatment report already exists
    abbreviated_treatment_report = AbbreviatedTreatmentReport.find_or_create_by(conservation_record_id: treatment_report.conservation_record_id) do |atr|
      # Convert simple text to rich text format
      atr.content = treatment_report.abbreviated_treatment_report
    end

    # Update content if the record already exists
    abbreviated_treatment_report.update(content: treatment_report.abbreviated_treatment_report)

    # Clear the simple text content from TreatmentReport
    treatment_report.update!(abbreviated_treatment_report: nil)

    abbreviated_treatment_report
  end

end
