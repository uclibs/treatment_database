# frozen_string_literal: true

class CostReturnReportsController < ApplicationController
  load_and_authorize_resource

  def create
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    CostReturnReport.create(cost_return_report_params)
    redirect_to "#{conservation_record_path(@conservation_record)}#cost-and-return-information", notice: 'Treatment record saved successfully'
  end

  def update
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @cost_return_report = @conservation_record.cost_return_report.update(cost_return_report_params)
    redirect_to "#{conservation_record_path(@conservation_record)}#cost-and-return-information", notice: 'Treatment record updated'
  end

  def destroy
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @cost_return_report = @conservation_record.cost_return_report
    @cost_return_report.destroy
    redirect_to "#{conservation_record_path(@conservation_record)}#cost-and-return-information"
  end

  private

  def cost_return_report_params
    params.require(:cost_return_report).permit(:shipping_cost, :repair_estimate, :repair_cost, :invoice_sent_to_business_office, :complete,
                                               :returned_to_origin, :note)
  end
end
