# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :authenticate_user!

  def help; end

  def results
    @search_string = params[:search]
    @records = case @search_string
               when /^[a-zA-Z]+\d{1,}/
                 ConservationRecord.where(item_record_number: @search_string)
               when /^\d+$/
                 ConservationRecord.where(id: @search_string)
               else
                 ConservationRecord.where('title LIKE ?', "%#{@search_string}%")
               end

    redirect_to conservation_record_path(@records.first) if @records.count == 1

    @records
  end
end
