# frozen_string_literal: true

class TreatmentReport < ApplicationRecord
  belongs_to :conservation_record

  has_paper_trail on: %i[update destroy]

  has_rich_text :abbreviated_treatment_report
end
