# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @results = []
    @cost_return_reports = CostReturnReport.where(complete: true).where(returned_to_origin: params[:start_date]..params[:end_date])
    @cost_return_reports.each do |csr|
      @results << csr if csr_has_in_house_repair_records?(csr)
    end
  end

  def create
    @results = []
    @cost_return_reports = CostReturnReport.where(complete: false).where(returned_to_origin: params[:start_date]..params[:end_date])
    @cost_return_reports.each do |csr|
      @results << csr unless csr_has_in_house_repair_records?(csr)
    end
  end

  private

  def csr_has_in_house_repair_records?(csr)
    csr.conservation_record.in_house_repair_records.exists?
  end
end
