# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InHouseRepairRecordsController, type: :controller do
  include Devise::TestHelpers
  render_views

  before do
    user = create(:user)
    sign_in user
  end

  let(:conservation_record) { create(:conservation_record) }
  let(:user) { create(:user) }
  let(:repair_type) { create(:controlled_vocabulary) }
  let(:valid_attributes) do
    {
      conservation_record_id: conservation_record.id,
      performed_by_user_id: user.id,
      repair_type: repair_type.id,
      minutes_spent: 10
    }
  end

  describe 'POST #create' do
    it 'creates a new in house repair record' do
      post :create, params: { in_house_repair_record: valid_attributes, conservation_record_id: conservation_record.id }
      expect(response).to redirect_to(conservation_record)
    end
  end

  describe 'DELETE #destroy' do
    it 'removes an in house repair record' do
      in_house_repair_record = InHouseRepairRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: in_house_repair_record.to_param, conservation_record_id: conservation_record.id }
      end.to change(InHouseRepairRecord, :count).by(-1)
    end
  end
end
