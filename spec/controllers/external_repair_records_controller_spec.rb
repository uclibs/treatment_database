# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalRepairRecordsController, type: :controller do
  include Devise::TestHelpers
  render_views

  before do
    user = create(:user)
    sign_in user
  end

  let(:conservation_record) { create(:conservation_record) }
  let(:user) { create(:user) }
  let(:repair_type) { create(:controlled_vocabulary) }
  let(:vendor) { create(:vendor) }
  let(:valid_attributes) do
    {
      conservation_record_id: conservation_record.id,
      repair_type: repair_type.id
    }
  end

  describe 'POST #create' do
    it 'creates a new in house repair record' do
      post :create, params: { external_repair_record: valid_attributes, conservation_record_id: conservation_record.id }
      expect(response).to redirect_to(conservation_record)
    end
  end

  describe 'DELETE #destroy' do
    it 'removes an in house repair record' do
      external_repair_record = ExternalRepairRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: external_repair_record.to_param, conservation_record_id: conservation_record.id }
      end.to change(ExternalRepairRecord, :count).by(-1)
    end
  end
end
