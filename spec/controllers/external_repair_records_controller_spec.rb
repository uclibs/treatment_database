# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalRepairRecordsController, type: :controller do
  render_views

  before do
    user = create(:user, role: 'standard')
    controller_login_as(user)
  end

  let(:conservation_record) { create(:conservation_record) }
  let(:user) { create(:user, role: 'standard') }
  let(:repair_type) { create(:controlled_vocabulary) }
  let(:valid_attributes) do
    {
      conservation_record_id: conservation_record.id,
      performed_by_vendor_id: '1',
      repair_type: repair_type.id,
      other_note: 'Some other note'
    }
  end

  describe 'POST #create' do
    it 'creates a new in house repair record' do
      post :create, params: { external_repair_record: valid_attributes, conservation_record_id: conservation_record.id }
      expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#external-repairs")
    end

    it 'validates for required params' do
      valid_attributes.delete(:repair_type)
      post :create, params: { external_repair_record: valid_attributes, conservation_record_id: conservation_record.id }
      expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#external-repairs")
      expect(subject.request.flash[:notice]).to have_content('External repair not save')
    end
  end

  describe 'DELETE #destroy' do
    it 'removes an in house repair record' do
      external_repair_record = ExternalRepairRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: external_repair_record.to_param, conservation_record_id: conservation_record.id }
      end.to change(ExternalRepairRecord, :count).by(-1)
      expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#external-repairs")
    end
  end
end
