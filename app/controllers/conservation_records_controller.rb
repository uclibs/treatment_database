# frozen_string_literal: true

class ConservationRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_treatment_report, only: %i[show edit update destroy]
  before_action :set_cost_return_report, only: %i[show edit update destroy]
  before_action :set_departments
  load_and_authorize_resource

  # GET /conservation_records
  # GET /conservation_records.json
  def index
    @pagy, @conservation_records = pagy(ConservationRecord.order(id: :desc), items: 100)
  end

  # GET /conservation_records/1
  # GET /conservation_records/1.json
  def show
    @users = User.all
    @repair_types = ControlledVocabulary.where(vocabulary: 'repair_type', active: true)
    @contract_conservators = ControlledVocabulary.where(vocabulary: 'contract_conservator', active: true)
    @housing = ControlledVocabulary.where(vocabulary: 'housing', active: true)
    @in_house_repairs = @conservation_record.in_house_repair_records
    @external_repairs = @conservation_record.external_repair_records
    @con_tech_records = @conservation_record.con_tech_records
    @staff_codes = StaffCode.all
  end

  # GET /conservation_records/new
  def new
    @conservation_record = ConservationRecord.new
  end

  # GET /conservation_records/1/edit
  def edit; end

  # POST /conservation_records
  # POST /conservation_records.json
  def create
    @conservation_record = ConservationRecord.new(conservation_record_params)
    respond_to do |format|
      if @conservation_record.save
        format.html { redirect_to @conservation_record, notice: 'Conservation record was successfully created.' }
        format.json { render :show, status: :created, location: @conservation_record }
      else
        format.html { render :new }
        format.json { render json: @conservation_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conservation_records/1
  # PATCH/PUT /conservation_records/1.json
  def update
    respond_to do |format|
      if @conservation_record.update(conservation_record_params)
        format.html { redirect_to @conservation_record, notice: 'Conservation record was successfully updated.' }
        format.json { render :show, status: :ok, location: @conservation_record }
      else
        format.html { render :edit }
        format.json { render json: @conservation_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conservation_records/1
  # DELETE /conservation_records/1.json
  def destroy
    @conservation_record.destroy
    respond_to do |format|
      format.html { redirect_to conservation_records_url, notice: 'Conservation record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def conservation_worksheet
    @conservation_record = ConservationRecord.find(params[:id])
    @base_64_form_image = "data:image/png;base64,#{Rails.public_path.join('worksheet_form_image.base64').read}"

    send_data build_pdf('conservation_worksheet'), filename: "#{@conservation_record.title.truncate(25, omission: '')}_conservation_worksheet.pdf",
                                                   type: 'application/pdf', disposition: 'inline'
  end

  def treatment_report
    @conservation_record = ConservationRecord.find(params[:id])
    send_data build_pdf('treatment_report_pdf'), filename: "#{@conservation_record.title.truncate(25, omission: '')}_treatment_report.pdf",
                                                 type: 'application/pdf', disposition: 'inline'
  end

  def abbreviated_treatment_report
    @conservation_record = ConservationRecord.find(params[:id])
    send_data build_pdf('abbreviated_treatment_report_pdf'),
               filename: "#{@conservation_record.title.truncate(25, omission: '')}_abbreviated_treatment_report.pdf",
               type: 'application/pdf', disposition: 'inline'
  end

  def build_pdf(format)
    html = render_to_string "conservation_records/#{format}", layout: false
    kit = PDFKit.new(html, page_size: 'Letter')
    kit.to_pdf
  end

  def as_html(conservation_record)
    render template: 'conservation_records/conservation_worksheet',
           locals: { @conservation_record => conservation_record }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_treatment_report
    @conservation_record = ConservationRecord.find(params[:id])
    return unless @conservation_record.treatment_report.nil?

    @conservation_record.treatment_report = TreatmentReport.new
    @conservation_record.save
  end

  def set_cost_return_report
    @conservation_record = ConservationRecord.find(params[:id])
    return unless @conservation_record.cost_return_report.nil?

    @conservation_record.cost_return_report = CostReturnReport.new
    @conservation_record.save
  end

  def set_departments
    @departments = ControlledVocabulary.where(vocabulary: 'department', active: true)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def conservation_record_params
    params.require(:conservation_record).permit(
      :date_received_in_preservation_services,
      :department,
      :title,
      :author,
      :imprint,
      :call_number,
      :item_record_number,
      :digitization
    )
  end
end
