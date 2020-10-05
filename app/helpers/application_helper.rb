# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def controlled_vocabulary_lookup(vocabulary_id)
    c = ControlledVocabulary.find(vocabulary_id)
    c.key
  end
end
