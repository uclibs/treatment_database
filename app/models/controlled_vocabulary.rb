# frozen_string_literal: true

class ControlledVocabulary < ApplicationRecord
  validates :vocabulary, :key, presence: true
end
