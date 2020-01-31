# frozen_string_literal: true

class TreatmentReport < ApplicationRecord
  belongs_to :conservation_record
  
  has_paper_trail
end
