require 'rails_helper'

RSpec.describe "ControlledVocabularies", type: :request do
  describe "GET /controlled_vocabularies" do
    it "works! (now write some real specs)" do
      get controlled_vocabularies_path
      expect(response).to have_http_status(200)
    end
  end
end
