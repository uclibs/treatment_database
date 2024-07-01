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

  # Creates and returns the path for an image being handled by webpack
  # Use like: <%= image_tag webpack_image_path('delete.png'), class: 'delete-icon', alt: 'Delete' %>
  # Exact image_name to be passed in can be determined from the manifest.json file in the public/build directory
  def webpack_image_path(image_name)
    # Determine the base path based on the environment
    base_path = Rails.env.production? ? '/treatment_database/build' : '/build'

    manifest_path = Rails.public_path.join('build/manifest.json')
    manifest = JSON.parse(File.read(manifest_path))
    "#{base_path}/#{manifest[image_name]}"
  end

  # Creates and returns the path for a stylesheet file being handled by webpack
  def webpack_stylesheet_path
    # Determine the base path based on the environment
    base_path = Rails.env.production? ? '/treatment_database/build' : '/build'

    manifest_path = Rails.public_path.join('build/manifest.json')
    manifest = JSON.parse(File.read(manifest_path))
    "#{base_path}/#{manifest['application.css']}"
  end

  # Creates and returns the path for the javascript file being handled by webpack
  def webpack_javascript_path
    # Determine the base path based on the environment
    base_path = Rails.env.production? ? '/treatment_database/build' : '/build'

    manifest_path = Rails.public_path.join('build/manifest.json')
    manifest = JSON.parse(File.read(manifest_path))
    "#{base_path}/#{manifest['application.js']}"
  end
end
