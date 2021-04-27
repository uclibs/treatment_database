class ReportsController < ApplicationController
 def index
  @results = []
  @CostReturnReports = CostReturnReport.where(complete: true).where(returned_to_origin: params[:start_date]..params[:end_date])
  @CostReturnReports.each do |csr|
    if csr_has_in_house_repair_records?(csr) 
      @results << csr
    end
  end
 end

 def create
  @results = []
  @CostReturnReports = CostReturnReport.where(complete: false).where(returned_to_origin: params[:start_date]..params[:end_date])
  @CostReturnReports.each do |csr|
    unless csr_has_in_house_repair_records?(csr)
      @results << csr
    end
  end
 end


 private
 def csr_has_in_house_repair_records?(csr)
  csr.conservation_record.in_house_repair_records.exists?
 end

end
