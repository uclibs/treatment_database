# frozen_string_literal: true

class InHouseRepairRecord < ApplicationRecord
  belongs_to :staff_code
  belongs_to :conservation_record
  validates :performed_by_user_id, :minutes_spent, :repair_type, presence: true

  has_paper_trail
end
