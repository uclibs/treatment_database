# frozen_string_literal: true

class ReportsController < ApplicationController
  load_and_authorize_resource

  def index
    @reports = Report.all
  end

  def create
    DataExportJob.perform_now
    flash[:notice] = "#{Report.last.csv_file.filename} is ready below."
    redirect_to reports_path
  end

  def destroy
    @report.csv_file.purge
    @report.destroy
    redirect_to reports_path
  end
end
