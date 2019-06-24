class ConservationRecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conservation_record, only: [:show, :edit, :update, :destroy]

  # GET /conservation_records
  # GET /conservation_records.json
  def index
    @conservation_records = ConservationRecord.all
  end

  # GET /conservation_records/1
  # GET /conservation_records/1.json
  def show
    @users = User.all
    @repair_types = ControlledVocabulary.where(vocabulary: 'repair_type', active: true)
    @contract_conservators = ControlledVocabulary.where(vocabulary: 'contract_conservator', active: true)
    @in_house_repairs = @conservation_record.in_house_repair_records
    @external_repairs = @conservation_record.external_repair_records
  end

  # GET /conservation_records/new
  def new
    @conservation_record = ConservationRecord.new
  end

  # GET /conservation_records/1/edit
  def edit
  end

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
    @base_64_form_image = 'data:image/png;base64,' + File.open(File.join(Rails.root, "public", "worksheet_form_image.base64")).read
    html = render_to_string "conservation_records/conservation_worksheet", layout: false
    kit = PDFKit.new(html, :page_size => 'Letter')
    pdf = kit.to_file(File.join("tmp/", @conservation_record.title.parameterize.underscore + "_conservation_worksheet.pdf"))
    send_file pdf, type: "application/pdf", disposition: "attachment"
  end

  def download_image(url)
    return 'data:image/png;base64,' + Base64.encode64(open(url) { |io| io.read })
  end

  def as_html(conservation_record)
    render template: "conservation_records/conservation_worksheet",
      locals: { @conservation_record => conservation_record }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conservation_record
      @conservation_record = ConservationRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conservation_record_params
      params.require(:conservation_record).permit(:date_recieved_in_preservation_services, :department, :title, :author, :imprint, :call_number, :item_record_number, :digitization)
    end
end
