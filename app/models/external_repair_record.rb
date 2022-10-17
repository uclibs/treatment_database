# frozen_string_literal: true

class ExternalRepairRecord < ApplicationRecord
  belongs_to :conservation_record
  validates :performed_by_vendor_id, :repair_type, presence: true

  has_paper_trail
end
