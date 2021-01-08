# frozen_string_literal: true

class CostReturnReport < ApplicationRecord
  belongs_to :conservation_record
  has_paper_trail
end
