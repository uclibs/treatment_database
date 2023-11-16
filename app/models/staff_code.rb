# frozen_string_literal: true

class StaffCode < ApplicationRecord
  has_one :in_house_repair_record, dependent: :destroy
  validates :code, :points, presence: true
  validates :points, numericality: { only_integer: true }
end
