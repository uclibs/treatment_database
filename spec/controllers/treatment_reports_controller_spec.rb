# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TreatmentReportsController, type: :controller do
  render_views

  before do
    user = create(:user, role: 'admin')
    controller_login_as(user)
    controller_stub_authorization(user)
  end
  let(:conservation_record) { create(:conservation_record) }
  let(:valid_attributes) do
    housing_a = create(:controlled_vocabulary, vocabulary: 'housing', key: 'housing')
    {
      description_general_remarks: 'General Description Remarks',
      description_binding: 'Description Binding',
      description_textblock: 'Description Textblock',
      description_primary_support: 'Description Primary Support',
      description_medium: 'Description Medium',
      description_attachments_inserts: 'Description Attachments Inserts',
      description_housing: 'Description Housing',
      condition_summary: 'Condition Summary',
      condition_binding: 'Condition Binding',
      condition_textblock: 'Condition Textblock',
      condition_primary_support: 'Condition Primary Support',
      condition_medium: 'Condition Medium',
      condition_housing_id: housing_a.id,
      condition_housing_narrative: 'Condition Housing Narrative',
      condition_attachments_inserts: 'Condition Attachments Inserts',
      condition_previous_treatment: 'Condition Previous Treatment',
      condition_materials_analysis: 'Condition Materials Analysis',
      treatment_proposal_proposal: 'Treatment Proposal Proposal',
      treatment_proposal_housing_need_id: housing_a.id,
      treatment_proposal_factors_influencing_treatment: 'Treatment Propsal Factors Influencing Treatment',
      treatment_proposal_performed_treatment: 'Treatment Propsal Performed Treatment',
      treatment_proposal_housing_provided_id: housing_a.id,
      treatment_proposal_housing_narrative: 'Treatment Propsal Housing Narrative',
      treatment_proposal_storage_and_handling_notes: 'Treatment Proposal Storage Handling and Notes',
      treatment_proposal_total_treatment_time: 30,
      abbreviated_treatment_report: "Conservator's Note",
      conservation_record_id: conservation_record.id
    }
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new conservation record' do
        conservation_record = create(:conservation_record)
        post :create, params: { conservation_record_id: conservation_record.id, treatment_report: valid_attributes }
        expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#treatment-report-tab")
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        housing_a = create(:controlled_vocabulary, vocabulary: 'housing', key: 'housing')
        {
          description_general_remarks: 'General Description Remarks',
          description_binding: 'Description Binding',
          description_textblock: 'Description Textblock',
          description_primary_support: 'Description Support',
          description_medium: 'Description Medium',
          description_attachments_inserts: 'Description Attachments Inserts',
          description_housing: 'Description Housing',
          condition_summary: 'Condition Summary',
          condition_binding: 'Condition Binding',
          condition_textblock: 'Condition Textblock',
          condition_primary_support: 'Condition Primary Support',
          condition_medium: 'Condition Medium',
          condition_housing_id: housing_a.id,
          condition_housing_narrative: 'Condition Housing Narrative',
          condition_attachments_inserts: 'Condition Attachments Inserts',
          condition_previous_treatment: 'Condition Previous Treatment',
          condition_materials_analysis: 'Condition Materials Analysis',
          treatment_proposal_proposal: 'Treatment Proposal Proposal',
          treatment_proposal_housing_need_id: housing_a.id,
          treatment_proposal_factors_influencing_treatment: 'Treatment Propsal Factors Influencing Treatment',
          treatment_proposal_performed_treatment: 'Treatment Propsal Performed Treatment',
          treatment_proposal_housing_provided_id: housing_a.id,
          treatment_proposal_housing_narrative: 'Treatment Propsal Housing Narrative',
          treatment_proposal_storage_and_handling_notes: 'Treatment Proposal Storage Handling and Notes',
          treatment_proposal_total_treatment_time: 30,
          abbreviated_treatment_report: "Conservator's Note"
        }
      end
      it 'updates the Treatment Report' do
        treatment_report = TreatmentReport.create! valid_attributes
        put :update, params: { conservation_record_id: conservation_record.id, id: treatment_report.to_param, treatment_report: new_attributes }
        expect(response).to redirect_to("#{conservation_record_path(conservation_record)}#treatment-report-tab")
        treatment_report.reload
        expect(treatment_report.description_primary_support).to eq('Description Support')
      end
    end
  end
end
