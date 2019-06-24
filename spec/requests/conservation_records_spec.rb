# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ConservationRecords', type: :request do
  describe 'GET /conservation_records' do
    it 'works! (now write some real specs)' do
      get conservation_records_path
      expect(response).to have_http_status(200)
    end
  end
end
