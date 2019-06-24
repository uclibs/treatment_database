# frozen_string_literal: true

json.array! @controlled_vocabularies, partial: 'controlled_vocabularies/controlled_vocabulary', as: :controlled_vocabulary
