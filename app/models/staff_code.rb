# frozen_string_literal: true

class StaffCode < ApplicationRecord
  has_one :in_house_repair_record, dependent: :destroy
  validates :code, :points, presence: true
end
