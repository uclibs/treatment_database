# frozen_string_literal: true

module ConservationRecordsHelper
  def friendly_housing(id)
    if id.nil?
      return "No housing method selected."
    else
      ControlledVocabulary.find(id)
    end
  end
end
