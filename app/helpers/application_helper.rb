# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def controlled_vocabulary_lookup(vocabulary_id)
    return 'ID Missing' if vocabulary_id.nil?

    c = ControlledVocabulary.find(vocabulary_id)
    c.key
  end

  def user_display_name(id)
    user = User.find(id)
    user.display_name
  rescue ActiveRecord::RecordNotFound
    "User not found (ID: #{id})"
  end
end
