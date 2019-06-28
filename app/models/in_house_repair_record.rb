# frozen_string_literal: true

class InHouseRepairRecord < ApplicationRecord
  belongs_to :conservation_record
end
