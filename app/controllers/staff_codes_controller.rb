# frozen_string_literal: true

class StaffCodesController < ApplicationController
  before_action :set_staff_code, only: %i[show edit update destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /staff_codes or /staff_codes.json
  def index
    @staff_codes = StaffCode.all
  end

  # GET /staff_codes/1 or /staff_codes/1.json
  def show; end

  # GET /staff_codes/new
  def new
    @staff_code = StaffCode.new
  end

  # GET /staff_codes/1/edit
  def edit; end

  # POST /staff_codes or /staff_codes.json
  def create
    @staff_code = StaffCode.new(staff_code_params)

    respond_to do |format|
      if @staff_code.save
        format.html { redirect_to @staff_code, notice: 'Staff code was successfully created.' }
        format.json { render :show, status: :created, location: @staff_code }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @staff_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staff_codes/1 or /staff_codes/1.json
  def update
    respond_to do |format|
      if @staff_code.update(staff_code_params)
        format.html { redirect_to @staff_code, notice: 'Staff code was successfully updated.' }
        format.json { render :show, status: :ok, location: @staff_code }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @staff_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staff_codes/1 or /staff_codes/1.json
  def destroy
    @staff_code.destroy
    respond_to do |format|
      format.html { redirect_to staff_codes_url, notice: 'Staff code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_staff_code
    @staff_code = StaffCode.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def staff_code_params
    params.require(:staff_code).permit(:code, :points)
  end
end
