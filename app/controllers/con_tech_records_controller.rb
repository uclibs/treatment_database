# frozen_string_literal: true

class ConTechRecordsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def create
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @con_tech_record = @conservation_record.con_tech_records.create(create_params)
    if @con_tech_record.valid?
      redirect_to conservation_record_path(@conservation_record)
    else
      redirect_to conservation_record_path(@conservation_record),
                  notice: "Conservator/Technician record not saved: #{@con_tech_record.errors.full_messages[0]}"
    end
  end

  def destroy
    @conservation_record = ConservationRecord.find(params[:conservation_record_id])
    @con_tech_record = @conservation_record.con_tech_records.find(params[:id])
    @con_tech_record.destroy
    redirect_to conservation_record_path(@conservation_record)
  end

  private

  def create_params
    params.require(:con_tech_record).permit(:performed_by_user_id)
  end
end
