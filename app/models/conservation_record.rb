# frozen_string_literal: true

class ConservationRecord < ApplicationRecord
  has_many :in_house_repair_records, dependent: :destroy
  has_many :external_repair_records, dependent: :destroy
end
