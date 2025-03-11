# frozen_string_literal: true

class InHouseRepairRecordsController < ApplicationController
  load_and_authorize_resource

  def create
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @repair_record = @conservation_record.in_house_repair_records.create(create_params)
    if @repair_record.valid?
      redirect_to "#{conservation_record_path(@conservation_record)}#in-house-repairs"
    else
      redirect_to "#{conservation_record_path(@conservation_record)}#in-house-repairs",
                  notice: "In house repair not saved: #{@repair_record.errors.full_messages[0]}"
    end
  end

  def destroy
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @repair_record = @conservation_record.in_house_repair_records.find(params[:id])
    @repair_record.destroy
    redirect_to "#{conservation_record_path(@conservation_record)}#in-house-repairs"
  end

  private

  def create_params
    params.require(:in_house_repair_record).permit(:performed_by_user_id, :repair_type, :minutes_spent, :other_note, :staff_code_id)
  end
end
