# frozen_string_literal: true

class ActivityController < ApplicationController
  authorize_resource class: false

  def index
    @pagy, @versions = pagy(PaperTrail::Version.order(created_at: :desc), items: 50)
  end

  def show
    @version = PaperTrail::Version.find(params[:id])
    @changeset = @version.changeset
    @other_versions = PaperTrail::Version.where(item_id: @version.item_id, item_type: @version.item_type).order(created_at: :desc)
  end
end
