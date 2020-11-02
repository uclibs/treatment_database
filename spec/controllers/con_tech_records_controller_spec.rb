# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConTechRecordsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    user = create(:user, role: 'admin')
    sign_in user
  end

  let(:conservation_record) { create(:conservation_record) }
  let(:user) { create(:user, role: 'admin') }
  let(:valid_attributes) do
    {
      conservation_record_id: conservation_record.id,
      performed_by_user_id: user.id
    }
  end

  describe 'POST #create' do
    it 'creates a new conservators and technicians record' do
      post :create, params: { con_tech_record: valid_attributes, conservation_record_id: conservation_record.id }
      expect(response).to redirect_to(conservation_record)
    end
  end

  describe 'DELETE #destroy' do
    it 'removes conservation and technicians record' do
      con_tech_record = ConTechRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: con_tech_record.to_param, conservation_record_id: conservation_record.id }
      end.to change(ConTechRecord, :count).by(-1)
    end
  end
end
