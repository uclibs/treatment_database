# frozen_string_literal: true

class InHouseRepairRecord < ApplicationRecord
  belongs_to :staff_code

  belongs_to :conservation_record

  has_paper_trail
end
