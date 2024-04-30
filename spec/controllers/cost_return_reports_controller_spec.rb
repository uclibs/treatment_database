# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CostReturnReportsController, type: :controller do
  render_views

  before do
    user = create(:user, role: 'admin')
    controller_login_as(user)
    controller_stub_authorization(user)
  end

  let(:conservation_record) { create(:conservation_record) }
  let(:valid_attributes) do
    {
      shipping_cost: 100.10,
      repair_estimate: 110.10,
      repair_cost: 120.10,
      invoice_sent_to_business_office: Time.now.utc,
      complete: true,
      returned_to_origin: Time.now.utc,
      note: 'This is the note.',
      conservation_record_id: conservation_record.id
    }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new cost return report record' do
        conservation_record = create(:conservation_record)
        post :create, params: { conservation_record_id: conservation_record.id, cost_return_report: valid_attributes }
        expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#cost-and-return-information")
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'removes Cost Return Report' do
      cost_return_report = CostReturnReport.create! valid_attributes
      expect do
        delete :destroy, params: { conservation_record_id: conservation_record.id, id: cost_return_report.to_param }
      end.to change(CostReturnReport, :count).by(-1)
      expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#cost-and-return-information")
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          shipping_cost: 90.10,
          repair_estimate: 110.10,
          repair_cost: 130.10,
          invoice_sent_to_business_office: Time.now.utc,
          complete: true,
          returned_to_origin: Time.now.utc,
          note: 'This is the note.'
        }
      end
      it 'updates Cost Return Report' do
        cost_return_report = CostReturnReport.create! valid_attributes
        put :update, params: { conservation_record_id: conservation_record.id, id: cost_return_report.to_param, cost_return_report: new_attributes }
        expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#cost-and-return-information")
        cost_return_report.reload
        expect(cost_return_report.repair_estimate).to eq(110.10)
        expect(cost_return_report.repair_cost).to eq(130.10)
      end
    end
  end
end
