# frozen_string_literal: true

class CostReturnReport < ApplicationRecord
  belongs_to :conservation_record
  has_many :in_house_repair_records, through: :conservation_record
  has_paper_trail
end
