# frozen_string_literal: true

class AbbreviatedTreatmentReportsController < ApplicationController
  before_action :set_abbreviated_treatment_report, only: [:edit, :update]
  before_action :set_conservation_record

  # GET /conservation_records/:conservation_record_id/abbreviated_treatment_reports/new
  def new
    @abbreviated_treatment_report = @conservation_record.abbreviated_treatment_reports.build
  end

  # GET /conservation_records/:conservation_record_id/abbreviated_treatment_reports/:id/edit
  def edit
    @abbreviated_treatment_report = @conservation_record.abbreviated_treatment_report
  end

  def edit
    @abbreviated_treatment_report = @conservation_record.abbreviated_treatment_report

    unless @abbreviated_treatment_report
      redirect_to new_conservation_record_abbreviated_treatment_report_path(@conservation_record), alert: 'No Abbreviated Treatment Report found. Please create one.'
    end
  end

  def create_or_update
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @abbreviated_treatment_report = @conservation_record.abbreviated_treatment_report

    if @abbreviated_treatment_report.nil?
      # If no AbbreviatedTreatmentReport exists, build and save a new one
      @abbreviated_treatment_report = @conservation_record.build_abbreviated_treatment_report(abbreviated_treatment_report_params)
    else
      # If it exists, just update it
      @abbreviated_treatment_report.assign_attributes(abbreviated_treatment_report_params)
    end

    if @abbreviated_treatment_report.save
      render json: { message: "Abbreviated Treatment Report successfully created or updated." }, status: :ok
    else
      render json: @abbreviated_treatment_report.errors, status: :unprocessable_entity
    end
  end


  def create
    @treatment_report = @conservation_record.treatment_report
    @abbreviated_treatment_report = @treatment_report.abbreviated_treatment_report || @treatment_report.build_abbreviated_treatment_report

    @abbreviated_treatment_report.assign_attributes(abbreviated_treatment_report_params)

    if @abbreviated_treatment_report.save
      render json: { message: "Abbreviated Treatment Report successfully created." }, status: :created
    else
      render json: @abbreviated_treatment_report.errors, status: :unprocessable_entity
    end
  end

  def update
    @treatment_report = @conservation_record.treatment_report
    @abbreviated_treatment_report = @treatment_report.abbreviated_treatment_report

    if @abbreviated_treatment_report.nil?
      render json: { error: "Abbreviated Treatment Report not found." }, status: :not_found
      return
    end

    if @abbreviated_treatment_report.update(abbreviated_treatment_report_params)
      render json: { message: "Abbreviated Treatment Report successfully updated." }, status: :ok
    else
      render json: @abbreviated_treatment_report.errors, status: :unprocessable_entity
    end
  end


  private
  def set_abbreviated_treatment_report
    @abbreviated_treatment_report = @conservation_record.abbreviated_treatment_reports.find(params[:id])
  end

  def set_conservation_record
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
  end

  def abbreviated_treatment_report_params
    params.require(:abbreviated_treatment_report).permit(:content, :conservation_record_id, :treatment_report_id)
  end

end

