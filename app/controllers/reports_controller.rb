class ReportsController < ApplicationController
 def new
  results = []
  @CostReturnReports = CostReturnReport.where(complete: true).where(returned_to_origin: params[:start_date]..params[:end_date])
  @CostReturnReports.each do |csr|
    if csr_has_in_house_repair_records?(csr) 
      results << csr
    end
  end
 redirect_to reports_path(@results, param: 'display')
 end

 def index
  @results = params[:param]
 end

 private
 def csr_has_in_house_repair_records?(csr)
  csr.conservation_record.in_house_repair_records
 end

end
