# frozen_string_literal: true

class TreatmentReport < ApplicationRecord
  belongs_to :conservation_record
  has_one :abbreviated_treatment_report, class_name: 'AbbreviatedTreatmentReport', dependent: :destroy

  has_paper_trail on: %i[update destroy]
end
