# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ControlledVocabularies', type: :request do
  before do
    user = create(:user, role: 'standard')
    sign_in user
  end

  describe 'GET /controlled_vocabularies' do
    it 'redirects to the homepage when requested by a standard user' do
      get controlled_vocabularies_path
      expect(response).to have_http_status(302)
    end
  end
end
