# frozen_string_literal: true

class ActivityController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: false

  def index
    @pagy, @versions = pagy(PaperTrail::Version.all, items: 50)
  end

  def show
    @version = PaperTrail::Version.find(params[:id])
    @other_versions = PaperTrail::Version.where(item_id: @version.item_id, item_type: @version.item_type).order('created_at DESC')
  end
end
