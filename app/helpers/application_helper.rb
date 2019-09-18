# frozen_string_literal: true

module ApplicationHelper
  def controlled_vocabulary_lookup(vocabulary_id)
    c = ControlledVocabulary.find(vocabulary_id)
    c.key
  end
end
