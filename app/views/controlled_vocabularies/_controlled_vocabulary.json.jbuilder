# frozen_string_literal: true

json.extract! controlled_vocabulary, :id, :vocabulary, :key, :active, :favorite, :created_at, :updated_at
json.url controlled_vocabulary_url(controlled_vocabulary, format: :json)
