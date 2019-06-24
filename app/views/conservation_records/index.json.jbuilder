# frozen_string_literal: true

json.array! @conservation_records, partial: 'conservation_records/conservation_record', as: :conservation_record
