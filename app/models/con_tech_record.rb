# frozen_string_literal: true

class ConTechRecord < ApplicationRecord
  belongs_to :conservation_record
  validates :performed_by_user_id, presence: true
end
