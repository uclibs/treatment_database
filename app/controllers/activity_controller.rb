# frozen_string_literal: true

class ActivityController < ApplicationController
  def index; end

  def show
    @version = PaperTrail::Version.find(params[:id])
    @other_versions = PaperTrail::Version.where(item_id: @version.item_id, item_type: @version.item_type).order('created_at DESC')
  end
end
