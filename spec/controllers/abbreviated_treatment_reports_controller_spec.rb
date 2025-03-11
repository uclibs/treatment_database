# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbbreviatedTreatmentReportsController, type: :controller do
  let(:user) { create(:user, role: 'admin') }
  render_views

  before do
    controller_login_as(user)
  end

  describe 'POST #create' do
    it 'creates a new conservation record' do
      conservation_record = create(:conservation_record)
      post :create, params: { conservation_record_id: conservation_record.id, abbreviated_treatment_report: nil }
      expect(response).to redirect_to(conservation_record_path(conservation_record))
    end
  end
end
