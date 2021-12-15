# frozen_string_literal: true

json.extract! conservation_record, :id, :date_received_in_preservation_services, :department, :title, :author, :imprint, :call_number, :item_record_number, :digitization, :created_at, :updated_at
json.url conservation_record_url(conservation_record, format: :json)
