# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InHouseRepairRecordsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    user = create(:user, role: 'standard')
    sign_in user
  end

  let(:conservation_record) { create(:conservation_record) }
  let(:user) { create(:user, role: 'standard') }
  let(:repair_type) { create(:controlled_vocabulary) }
  let!(:staff_code) { create(:staff_code, code: 'C', points: 10) }
  let(:valid_attributes) do
    {
      conservation_record_id: conservation_record.id,
      performed_by_user_id: user.id,
      repair_type: repair_type.id,
      minutes_spent: 10,
      other_note: 'Some other note',
      staff_code_id: staff_code.id

    }
  end

  let(:in_valid_attributes) do
    {
      conservation_record_id: conservation_record.id,
      performed_by_user_id: user.id,
      repair_type: repair_type.id,
      minutes_spent: 10,
      other_note: 'Some other note'
    }
  end

  describe 'POST #create' do
    it 'creates a new in house repair record' do
      post :create, params: { in_house_repair_record: valid_attributes, conservation_record_id: conservation_record.id }
      expect(response).to redirect_to(conservation_record)
    end

    it 'does not have valid staff code to create in house repair record' do
      post :create, params: { in_house_repair_record: in_valid_attributes, conservation_record_id: conservation_record.id }
      expect(response).to_not be_successful
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
