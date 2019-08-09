# frozen_string_literal: true

class SearchController < ApplicationController
  def results
    @search_string = params[:search]
    @records = if @search_string =~ /^i\d{1,}/
                 ConservationRecord.where(item_record_number: @search_string)
               elsif @search_string =~ /^\d+$/
                 ConservationRecord.where(id: @search_string)
               else
                 ConservationRecord.where('title LIKE ?', "%#{@search_string}%")
               end

    redirect_to conservation_record_path(@records.first) if @records.count == 1

    @records
  end
end
