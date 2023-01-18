# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def controlled_vocabulary_lookup(vocabulary_id)
    return 'ID Missing' if vocabulary_id.nil?

    c = ControlledVocabulary.find(vocabulary_id)
    c.key
  end
end
