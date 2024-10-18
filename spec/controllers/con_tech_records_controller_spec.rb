# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConTechRecordsController, type: :controller do
  render_views
  let(:user) { create(:user, role: 'admin') }

  before do
    controller_login_as(user)
    controller_stub_authorization(user)
  end

  let(:conservation_record) { create(:conservation_record) }
  let(:valid_attributes) do
    {
      performed_by_user_id: user.id
    }
  end

  let(:invalid_attributes) do
    {
      performed_by_user_id: nil
    }
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new ConTechRecord and redirects' do
        expect do
          post :create, params: { con_tech_record: valid_attributes, conservation_record_id: conservation_record.id }
        end.to change(ConTechRecord, :count).by(1)

        expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#conservators-and-technicians")
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new ConTechRecord and redirects with an error message' do
        expect do
          post :create, params: { con_tech_record: invalid_attributes, conservation_record_id: conservation_record.id }
        end.to change(ConTechRecord, :count).by(0)

        expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#conservators-and-technicians")
        expect(flash[:notice]).to match(%r{Conservator/Technician record not saved})
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with a valid record' do
      it 'destroys the requested ConTechRecord and redirects' do
        con_tech_record = ConTechRecord.create!(valid_attributes.merge(conservation_record_id: conservation_record.id))

        expect do
          delete :destroy, params: { id: con_tech_record.to_param, conservation_record_id: conservation_record.id }
        end.to change(ConTechRecord, :count).by(-1)

        expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#conservators-and-technicians")
      end
    end

    context 'when the record does not exist' do
      it 'does not change the count and renders a 404 page' do
        expect do
          delete :destroy, params: { conservation_record_id: conservation_record.id, id: 'non-existent-id' }
        end.not_to change(ConTechRecord, :count)

        expect(response).to have_http_status(:not_found)
        expect(response).to render_template('errors/not_found')
      end
    end
  end

  describe 'authentication' do
    context 'when not authenticated' do
      before do
        controller_logout
      end

      it 'redirects to the login page for create' do
        post :create, params: { con_tech_record: valid_attributes, conservation_record_id: conservation_record.id }
        expect(response).to redirect_to(new_session_path)
      end

      it 'redirects to the login page for destroy' do
        con_tech_record = ConTechRecord.create!(valid_attributes.merge(conservation_record_id: conservation_record.id))
        delete :destroy, params: { id: con_tech_record.to_param, conservation_record_id: conservation_record.id }
        expect(response).to redirect_to(new_session_path)
      end
    end
  end
end
