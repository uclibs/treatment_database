# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  include_context 'rake' # This job relies on rake tasks

  let(:user) { create(:user, role: 'admin') }
  render_views

  before do
    ActiveJob::Base.queue_adapter = :test
    controller_login_as(user)
    controller_stub_authorization(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'executes DataExportJob' do
      expect { post :create }.to change { Report.count }.by 1
    end

    it 'redirects to reports index and show flash message' do
      post :create
      expect(response).to redirect_to reports_path
      expect(flash[:notice]).to be_present
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested conservation_record' do
      report_record = Report.create!
      expect do
        delete :destroy, params: { id: report_record.to_param }
      end.to change(Report, :count).by(-1)
    end
  end
end
