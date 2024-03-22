# frozen_string_literal: true

class AbbreviatedTreatmentReport < ApplicationRecord
  belongs_to :conservation_record
  belongs_to :treatment_report

  has_rich_text :content
  has_paper_trail on: %i[create update destroy]
end
