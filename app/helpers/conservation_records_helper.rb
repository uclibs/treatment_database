# frozen_string_literal: true

module ConservationRecordsHelper
  def date_returned(record)
    return if record.cost_return_report.blank?

    returned_date = record.cost_return_report.returned_to_origin
    returned_date.to_date if returned_date.present?
  end

  def friendly_housing(id)
    if id.nil?
      'No housing method selected.'
    else
      ControlledVocabulary.find(id).key
    end
  end
end
