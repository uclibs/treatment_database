# frozen_string_literal: true

class ExternalRepairRecordsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def create
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @repair_record = @conservation_record.external_repair_records.create(create_params)
    redirect_to conservation_record_path(@conservation_record)
  end

  def destroy
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @repair_record = @conservation_record.external_repair_records.find(params[:id])
    @repair_record.destroy
    redirect_to conservation_record_path(@conservation_record)
  end

  private

  def create_params
    params.require(:external_repair_record).permit(:performed_by_vendor_id, :repair_type, :other_note)
  end
end
