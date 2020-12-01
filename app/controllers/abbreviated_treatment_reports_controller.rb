# frozen_string_literal: true

class AbbreviatedTreatmentReportsController < ApplicationController
  def create
    @abbreviated_treatment_report = AbbreviatedTreatmentReport.new
    @abbreviated_treatment_report.conservation_record_id = params[:conservation_record_id]
    @abbreviated_treatment_report.save
    redirect_to conservation_record_path(@abbreviated_treatment_report.conservation_record)
  end
end
