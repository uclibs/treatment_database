# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaffCodes', type: :request do
  before do
    user = create(:user, role: 'standard')
    sign_in user
  end

  describe 'GET /staff_codes' do
    it 'works! (now write some real specs)' do
      get staff_codes_path
      expect(response).to have_http_status(200)
    end
  end
end
