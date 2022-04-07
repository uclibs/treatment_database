# frozen_string_literal: true

class InHouseRepairRecordsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def create
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @repair_record = @conservation_record.in_house_repair_records.create(create_params)
    redirect_to conservation_record_path(@conservation_record)
  end

  def destroy
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @repair_record = @conservation_record.in_house_repair_records.find(params[:id])
    @repair_record.destroy
    redirect_to conservation_record_path(@conservation_record)
  end

  private

  def create_params
    params.require(:in_house_repair_record).permit(:performed_by_user_id, :repair_type, :minutes_spent, :other_note)
  end
end
