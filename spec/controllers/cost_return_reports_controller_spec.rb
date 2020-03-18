require 'rails_helper'

RSpec.describe CostReturnReportsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    user = create(:user, role: 'admin')
    sign_in(user)
  end

  let(:valid_attributes) do
    {
      shipping_cost: 100.10,
      repair_estimate: 110.10,
      repair_cost: 120.10,
      invoice_sent_to_business_office: Time.now,
      complete: true,
      returned_to_origin: Time.now,
      note: "This is the note."
    }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new cost return report record' do
        conservation_record = create(:conservation_record)
        post :create, params: { conservation_record_id: conservation_record.id, cost_return_report: valid_attributes }
        expect(response).to redirect_to(conservation_record_path(conservation_record))
      end
    end
  end
end
