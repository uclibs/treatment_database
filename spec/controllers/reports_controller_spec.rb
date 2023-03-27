# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    ActiveJob::Base.queue_adapter = :test
    user = create(:user, role: 'standard')
    sign_in(user)
  end

  describe 'POST #create' do
    it 'executes DataExportJob' do
      expect { post :create }.to change { Report.count }.by 1
    end

    it 'redirects to reports index' do
      post :create
      expect(response).to redirect_to reports_path
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
