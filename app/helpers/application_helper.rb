# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  def controlled_vocabulary_lookup(vocabulary_id)
    return 'ID Missing' if vocabulary_id.nil?

    ControlledVocabulary.find_by(id: vocabulary_id)&.key
  end

  def user_display_name(id)
    user = User.find(id)
    user.display_name.squish
  rescue ActiveRecord::RecordNotFound
    "User not found (ID: #{id})"
  end
end
