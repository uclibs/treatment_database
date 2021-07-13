# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource

  def index
    query_base = search_params.present? ? CostReturnReport.all : CostReturnReport.none
    @q = query_base.ransack(search_params[:q])
    @results = @q.result(distinct: true).includes(:in_house_repair_records)
  end

  private

  def search_params
    params.permit(q: {})
  end
end
