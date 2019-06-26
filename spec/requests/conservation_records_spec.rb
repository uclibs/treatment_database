# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'ConservationRecords', type: :request do
  before do
    user = create(:user)
    sign_in user
  end
  
  describe 'GET /conservation_records' do
    it 'works! (now wr' do
      get conservation_records_path
      expect(response).to have_http_status(200)
    end
  end
end
