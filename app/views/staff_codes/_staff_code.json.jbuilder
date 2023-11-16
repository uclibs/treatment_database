# frozen_string_literal: true

json.extract! staff_code, :id, :code, :points, :created_at, :updated_at
json.url staff_code_url(staff_code, format: :json)
