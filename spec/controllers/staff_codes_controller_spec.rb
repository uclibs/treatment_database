# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaffCodesController, type: :controller do
  let(:valid_attributes) do
    {
      code: 'C',
      points: 10
    }
  end

  let(:invalid_attributes) do
    {
      code: nil,
      points: nil
    }
  end

  before do
    user = create(:user, role: 'admin')
    controller_login_as(user)
    controller_stub_authorization(user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      StaffCode.create! valid_attributes
      get :index, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      staff_code = StaffCode.create! valid_attributes
      get :show, params: { id: staff_code.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      staff_code = StaffCode.create! valid_attributes
      get :edit, params: { id: staff_code.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new StaffCode' do
        expect do
          post :create, params: { staff_code: valid_attributes }
        end.to change(StaffCode, :count).by(1)
      end

      it 'redirects to the created staff_code' do
        post :create, params: { staff_code: valid_attributes }
        expect(response).to redirect_to(StaffCode.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { staff_code: invalid_attributes }
        expect(response).to_not be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          code: 'C',
          points: 10
        }
      end

      it 'updates the requested staff_code' do
        staff_code = StaffCode.create! valid_attributes
        put :update, params: { id: staff_code.to_param, staff_code: new_attributes }
        staff_code.reload
        expect(response).to redirect_to(staff_code)
      end

      it 'redirects to the staff_code' do
        staff_code = StaffCode.create! valid_attributes
        put :update, params: { id: staff_code.to_param, staff_code: valid_attributes }
        expect(response).to redirect_to(staff_code)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        staff_code = StaffCode.create! valid_attributes
        put :update, params: { id: staff_code.to_param, staff_code: invalid_attributes }
        expect(response).to_not be_successful
      end
    end
  end
end
