# frozen_string_literal: true

class ConservationRecord < ApplicationRecord
  has_many :in_house_repair_records, dependent: :destroy
  has_many :external_repair_records, dependent: :destroy
  has_many :con_tech_records, dependent: :destroy
  has_one :treatment_report, dependent: :destroy
  has_one :abbreviated_treatment_report, dependent: :destroy
  has_one :cost_return_report, dependent: :destroy

  validates :department, :title, :author, :imprint, :call_number, :item_record_number, presence: true

  has_paper_trail
end
