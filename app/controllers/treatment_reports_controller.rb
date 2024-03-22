# frozen_string_literal: true

class TreatmentReportsController < ApplicationController
  before_action :convert_legacy_treatment_report, except: [:destroy]

  def create
    @treatment_report = TreatmentReport.new(treatment_report_params)
    @treatment_report.conservation_record_id = params[:conservation_record_id]
    @treatment_report.save

    flash
    redirect_to "#{conservation_record_path(@treatment_report.conservation_record)}#treatment-report-tab", notice: 'Treatment record saved successfully!'
  end

  def update
    @treatment_report = TreatmentReport.find(params[:id])

    @treatment_report.update(treatment_report_params)
    redirect_to "#{conservation_record_path(@treatment_report.conservation_record)}#treatment-report-tab",
                notice: 'Treatment Record updated successfully!'
  end

  private

  def convert_legacy_treatment_report
    treatment_report = TreatmentReport.find(params[:id])
    convert_legacy_treatment_report_to_rtf(treatment_report)
  end

  def treatment_report_params
    params.require(:treatment_report).permit(:description_general_remarks,
                                             :description_binding,
                                             :description_textblock,
                                             :description_primary_support,
                                             :description_medium,
                                             :description_attachments_inserts,
                                             :description_housing,
                                             :condition_summary,
                                             :condition_binding,
                                             :condition_textblock,
                                             :condition_primary_support,
                                             :condition_medium,
                                             :condition_housing_id,
                                             :condition_housing_narrative,
                                             :condition_attachments_inserts,
                                             :condition_previous_treatment,
                                             :condition_materials_analysis,
                                             :treatment_proposal_proposal,
                                             :treatment_proposal_housing_need_id,
                                             :treatment_proposal_factors_influencing_treatment,
                                             :treatment_proposal_performed_treatment,
                                             :treatment_proposal_housing_provided_id,
                                             :treatment_proposal_housing_narrative,
                                             :treatment_proposal_storage_and_handling_notes,
                                             :treatment_proposal_total_treatment_time)
  end
end
