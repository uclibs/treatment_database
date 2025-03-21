# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConservationRecordsController, type: :controller do
  let(:user) { create(:user, role: 'admin') }
  render_views

  before do
    controller_login_as(user)
  end

  # This should return the minimal set of attributes required to create a valid
  # ConservationRecord. As you add validations to ConservationRecord, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    department_a = create(:controlled_vocabulary, vocabulary: 'department', key: 'Department A')
    {
      department: department_a.id,
      title: 'Farewell to Arms and Legs and Eyes and Ears',
      author: 'A Good Writer',
      imprint: 'Dutton',
      call_number: 'P102.3294.3920',
      item_record_number: 'i452',
      digitization: true,
      date_received_in_preservation_services: Date.new,
      treatment_report: TreatmentReport.new,
      abbreviated_treatment_report: AbbreviatedTreatmentReport.new
    }
  end

  let(:invalid_attributes) do
    {
      department: '',
      title: '',
      author: '',
      imprint: '',
      call_number: '',
      item_record_number: '',
      digitization: nil,
      date_received_in_preservation_services: nil
    }
  end

  describe 'GET #index' do
    it 'returns a success response' do
      ConservationRecord.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end

    it 'has the appropriate content' do
      ConservationRecord.create! valid_attributes
      get :index, params: {}
      expect(response.body).to have_content('Conservation Records')
      expect(response.body).to have_content('Farewell to Arms')
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      conservation_record = ConservationRecord.create! valid_attributes
      get :show, params: { id: conservation_record.to_param }
      expect(response).to be_successful
    end

    it 'returns repair_types select options ordered by favorites' do
      term = ControlledVocabulary.find_by(key: 'Training')
      term.update(favorite: true)
      conservation_record = ConservationRecord.create! valid_attributes
      get :show, params: { id: conservation_record.to_param }
      expect(controller.view_assigns['repair_types']).to start_with(term)
    end

    it 'returns housing select options ordered by favorites' do
      term = ControlledVocabulary.find_by(key: 'Tuxedo Box')
      term.update(favorite: true)
      conservation_record = ConservationRecord.create! valid_attributes
      get :show, params: { id: conservation_record.to_param }
      expect(controller.view_assigns['housing']).to start_with(term)
    end

    it 'returns contract_conservators select options ordered by favorites' do
      term = ControlledVocabulary.find_by(key: 'Richard Baker')
      term.update(favorite: true)
      conservation_record = ConservationRecord.create! valid_attributes
      get :show, params: { id: conservation_record.to_param }
      expect(controller.view_assigns['contract_conservators']).to start_with(term)
    end

    it 'returns departments select options ordered by favorites' do
      term = ControlledVocabulary.find_by(key: 'Chem-Bio Library')
      term.update(favorite: true)
      conservation_record = ConservationRecord.create! valid_attributes
      get :show, params: { id: conservation_record.to_param }
      expect(controller.view_assigns['departments']).to start_with(term)
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      conservation_record = ConservationRecord.create! valid_attributes
      get :edit, params: { id: conservation_record.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ConservationRecord' do
        expect do
          post :create, params: { conservation_record: valid_attributes }
        end.to change(ConservationRecord, :count).by(1)
      end

      it 'redirects to the created conservation_record' do
        post :create, params: { conservation_record: valid_attributes }
        expect(response).to redirect_to(ConservationRecord.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { conservation_record: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        department_b = create(:controlled_vocabulary, vocabulary: 'department', key: 'Department B')
        {
          department: department_b.id,
          title: 'An Uninteresting Book',
          author: 'A Poor Writer',
          imprint: 'Sribble',
          call_number: 'P102.3294.3921',
          item_record_number: 'i453',
          digitization: false,
          date_received_in_preservation_services: Date.new - 1
        }
      end

      it 'updates the requested conservation_record' do
        conservation_record = ConservationRecord.create! valid_attributes
        put :update, params: { id: conservation_record.to_param, conservation_record: new_attributes }
        conservation_record.reload
        expect(conservation_record.department).to eq(new_attributes[:department])
      end

      it 'redirects to the conservation_record' do
        conservation_record = ConservationRecord.create! valid_attributes
        put :update, params: { id: conservation_record.to_param, conservation_record: valid_attributes }
        expect(response).to redirect_to(conservation_record)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        conservation_record = ConservationRecord.create! valid_attributes
        put :update, params: { id: conservation_record.to_param, conservation_record: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested conservation_record' do
      conservation_record = ConservationRecord.create! valid_attributes
      expect do
        delete :destroy, params: { id: conservation_record.to_param }
      end.to change(ConservationRecord, :count).by(-1)
    end

    it 'redirects to the conservation_records list' do
      conservation_record = ConservationRecord.create! valid_attributes
      delete :destroy, params: { id: conservation_record.to_param }
      expect(response).to redirect_to(conservation_records_url)
    end
  end

  describe 'conservation_worksheet' do
    it 'sends a file' do
      conservation_record = ConservationRecord.create! valid_attributes
      get :conservation_worksheet, params: { id: conservation_record.id }
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_conservation_worksheet.pdf')
    end

    context 'with read_only user' do
      let(:read_user) { create(:user, role: 'read_only') }

      before do
        controller_login_as(read_user)
      end

      it 'sends a file' do
        conservation_record = ConservationRecord.create! valid_attributes
        get :conservation_worksheet, params: { id: conservation_record.id }
        expect(response.headers['Content-Type']).to eq('application/pdf')
        expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_conservation_worksheet.pdf')
      end
    end

    context 'with standard user' do
      let(:standard_user) { create(:user, role: 'standard') }

      before do
        controller_login_as(standard_user)
      end

      it 'sends a file' do
        conservation_record = ConservationRecord.create! valid_attributes
        get :conservation_worksheet, params: { id: conservation_record.id }
        expect(response.headers['Content-Type']).to eq('application/pdf')
        expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_conservation_worksheet.pdf')
      end
    end
  end

  describe 'treatment_report' do
    it 'sends a file' do
      conservation_record = ConservationRecord.create! valid_attributes
      get :treatment_report, params: { id: conservation_record.id }
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_treatment_report.pdf')
    end

    context 'with read_only user' do
      let(:read_user) { create(:user, role: 'read_only') }

      before do
        controller_login_as(read_user)
      end

      it 'redirects to home with an error' do
        conservation_record = ConservationRecord.create! valid_attributes
        get :treatment_report, params: { id: conservation_record.id }
        expect(response.headers['Content-Type']).to eq('application/pdf')
        expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_treatment_report.pdf')
      end
    end

    context 'with standard user' do
      let(:standard_user) { create(:user, role: 'standard') }

      before do
        controller_login_as(standard_user)
      end

      it 'sends a file' do
        conservation_record = ConservationRecord.create! valid_attributes
        get :treatment_report, params: { id: conservation_record.id }
        expect(response.headers['Content-Type']).to eq('application/pdf')
      end
    end
  end

  describe 'abbreviated_treatment_report' do
    it 'sends a file' do
      conservation_record = ConservationRecord.create! valid_attributes
      get :abbreviated_treatment_report, params: { id: conservation_record.id }
      expect(response.headers['Content-Type']).to eq('application/pdf')
      expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_abbreviated_treatment_report.pdf')
    end

    context 'with read_only user' do
      let(:read_user) { create(:user, role: 'read_only') }

      before do
        controller_login_as(read_user)
      end

      it 'sends a file' do
        conservation_record = ConservationRecord.create! valid_attributes
        get :abbreviated_treatment_report, params: { id: conservation_record.id }
        expect(response.headers['Content-Type']).to eq('application/pdf')
        expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_abbreviated_treatment_report.pdf')
      end
    end

    context 'with standard user' do
      let(:standard_user) { create(:user, role: 'standard') }

      before do
        controller_login_as(standard_user)
      end

      it 'sends a file' do
        conservation_record = ConservationRecord.create! valid_attributes
        get :abbreviated_treatment_report, params: { id: conservation_record.id }
        expect(response.headers['Content-Type']).to eq('application/pdf')
        expect(response.headers['Content-Disposition']).to have_content('Farewell to Arms and Legs_abbreviated_treatment_report.pdf')
      end
    end
  end
end
